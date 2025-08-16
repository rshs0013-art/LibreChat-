/// App configuration for enabling/disabling features
class AppConfig {
  /// Enable Firebase features (auth, analytics, etc.)
  /// Set to false to build without Firebase dependencies
  static const bool enableFirebase = false;
  
  /// Enable Google Sign-In
  /// Requires Firebase Auth to be enabled
  static const bool enableGoogleSignIn = enableFirebase;
  
  /// Enable Analytics
  static const bool enableAnalytics = enableFirebase;
  
  /// Enable Crashlytics
  static const bool enableCrashlytics = enableFirebase;
  
  /// Enable Remote Config
  static const bool enableRemoteConfig = enableFirebase;
  
  /// App name
  static const String appName = 'Index';
  
  /// App version
  static const String appVersion = '1.0.0';
  
  /// Company info
  static const String companyName = 'Voxin';
  static const String companyWebsite = 'https://voxin.netlify.app/';
  static const String companyFoundedYear = '2021';
}