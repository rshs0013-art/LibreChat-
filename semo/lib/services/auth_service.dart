import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:logger/logger.dart";
import "package:index/config/app_config.dart";

class AuthService {
  factory AuthService() => _instance;
  AuthService._internal();

  static final AuthService _instance = AuthService._internal();

  final FirebaseAuth? _auth = AppConfig.enableFirebase ? FirebaseAuth.instance : null;
  final GoogleSignIn? _googleSignIn = AppConfig.enableGoogleSignIn ? GoogleSignIn() : null;
  final Logger _logger = Logger();
  
  // Simple guest mode when Firebase is disabled
  bool _isGuestAuthenticated = false;

  Future<OAuthCredential?> _getOAuthCredential() async {
    if (!AppConfig.enableGoogleSignIn || _googleSignIn == null) return null;
    
    try {
      final GoogleSignInAccount? user = await _googleSignIn!.signIn();
      if (user == null) return null;
      final GoogleSignInAuthentication auth = await user.authentication;
      return GoogleAuthProvider.credential(idToken: auth.idToken);
    } catch (e, s) {
      _logger.e("Failed to get OAuth Credential", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<UserCredential?> signIn() async {
    if (!AppConfig.enableFirebase || _auth == null) {
      // Simple guest mode when Firebase is disabled
      _isGuestAuthenticated = true;
      return null;
    }
    
    try {
      final OAuthCredential? credential = await _getOAuthCredential();

      if (credential == null) {
        throw Exception("OAuth Credential is null");
      }

      return await _auth!.signInWithCredential(credential);
    } catch (e, s) {
      _logger.e("Failed to authenticate", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<UserCredential?> signInAsGuest() async {
    if (!AppConfig.enableFirebase || _auth == null) {
      // Simple guest mode when Firebase is disabled
      _isGuestAuthenticated = true;
      return null;
    }
    
    try {
      return await _auth!.signInAnonymously();
    } catch (e, s) {
      _logger.e("Failed to sign in as guest", error: e, stackTrace: s);
      rethrow;
    }
  }

  bool isAuthenticated() {
    if (!AppConfig.enableFirebase || _auth == null) {
      // Return guest authentication status when Firebase is disabled
      return _isGuestAuthenticated;
    }
    
    try {
      User? user = getUser();
      return user != null;
    } catch (e, s) {
      _logger.e("Failed to check authentication status", error: e, stackTrace: s);
      rethrow;
    }
  }

  User? getUser() {
    if (!AppConfig.enableFirebase || _auth == null) {
      return null; // No user object when Firebase is disabled
    }
    
    try {
      return _auth!.currentUser;
    } catch (e, s) {
      _logger.e("Failed to get current user", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<UserCredential?> reAuthenticate() async {
    if (!AppConfig.enableFirebase || _auth == null) {
      return null; // No re-authentication when Firebase is disabled
    }
    
    try {
      if (_auth!.currentUser == null) {
        throw Exception("User is null");
      }

      final OAuthCredential? credential = await _getOAuthCredential();

      if (credential == null) {
        throw Exception("OAuth Credential is null");
      }

      return await _auth!.currentUser?.reauthenticateWithCredential(credential);
    } catch (e, s) {
      _logger.e("Failed to re-authenticate", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<dynamic> signOut() async {
    if (!AppConfig.enableFirebase) {
      _isGuestAuthenticated = false;
      return;
    }
    
    try {
      if (_googleSignIn != null) await _googleSignIn!.signOut();
      if (_auth != null) await _auth!.signOut();
    } catch (e, s) {
      _logger.e("Failed to sign out", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<dynamic> deleteAccount() async {
    if (!AppConfig.enableFirebase || _auth == null) {
      _isGuestAuthenticated = false;
      return;
    }
    
    try {
      if (_auth!.currentUser == null) {
        throw Exception("User is null");
      }

      await _auth!.currentUser?.delete();
    } catch (e, s) {
      _logger.e("Failed to delete account", error: e, stackTrace: s);
      rethrow;
    }
  }
}