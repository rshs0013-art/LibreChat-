import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "package:index/gen/assets.gen.dart";
import "package:index/screens/base_screen.dart";

class AboutScreen extends BaseScreen {
  const AboutScreen({super.key});

  @override
  BaseScreenState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends BaseScreenState<AboutScreen> {
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    String? url,
    IconData? icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (url != null)
              InkWell(
                onTap: () => _launchUrl(url),
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            else
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String url,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.web, color: Colors.blue),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _launchUrl(url),
      ),
    );
  }

  @override
  String get screenName => "About";

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Assets.images.appIcon.image(
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Index",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "A VOD streaming application",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Company Information
            _buildInfoCard(
              title: "المطور",
              content: "Voxin - شركة ناشئة تأسست عام 2021",
              icon: Icons.business,
            ),
            
            _buildInfoCard(
              title: "الموقع الإلكتروني",
              content: "https://voxin.netlify.app/",
              url: "https://voxin.netlify.app/",
              icon: Icons.web,
            ),
            
            // Projects Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "مشاريعنا",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            
            _buildProjectCard(
              title: "Index",
              url: "https://index-git-master-voxinappindexcom.vercel.app/",
              description: "تطبيق البث المرئي الحالي",
            ),
            
            _buildProjectCard(
              title: "Postyy",
              url: "https://postyy.netlify.app/",
              description: "منصة إدارة وسائل التواصل الاجتماعي",
            ),
            
            _buildProjectCard(
              title: "Build X",
              url: "#",
              description: "قريباً",
            ),
            
            const SizedBox(height: 32),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  Text(
                    "شكراً لاستخدام Index",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "© 2021-2025 Voxin. جميع الحقوق محفوظة.",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}