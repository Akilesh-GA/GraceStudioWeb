import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'portfolio_data.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioData.projects;
    final Color tColor = const Color(0xFF6D28D9);
    final Color neonPink = const Color(0xFFEC4899);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0615),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Our Portfolio",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 35),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 1.5,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];

                return GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(project['drive']!);
                    await launchUrl(url,
                        mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: (index.isEven ? tColor : neonPink)
                              .withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        project['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
