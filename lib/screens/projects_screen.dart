import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grace_studio/models/portfolio_data.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                // 🔹 Change this to 1.5 or higher for a rectangle shape
                childAspectRatio: 1.6,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];

                return GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(project['drive']!);
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: (index.isEven ? tColor : neonPink).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          // 1. Background Image
                          Positioned.fill(
                            child: Image.asset(
                              project['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // 2. Sophisticated Gradient Overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.3, 1.0], // Starts darker only at the bottom
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.9),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // 3. Content
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // Slightly smaller for better fit in rectangle
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  project['description']!,
                                  maxLines: 2, // Reduced lines for the thinner rectangle
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 11,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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