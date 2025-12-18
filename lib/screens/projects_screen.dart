import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color tColor = Color(0xFF1ABC9C);

    // Sample project data
    final List<Map<String, String>> projects = [
      {
        'title': 'Wedding Photography',
        'image': 'https://via.placeholder.com/400x250.png?text=Wedding+Photography',
        'description': 'Capturing beautiful moments of weddings and celebrations.'
      },
      {
        'title': 'Corporate Events',
        'image': 'https://via.placeholder.com/400x250.png?text=Corporate+Events',
        'description': 'Professional photography for corporate and business events.'
      },
      {
        'title': 'Portrait Sessions',
        'image': 'https://via.placeholder.com/400x250.png?text=Portrait+Sessions',
        'description': 'Individual or family portrait sessions with creativity.'
      },
      {
        'title': 'Travel Photography',
        'image': 'https://via.placeholder.com/400x250.png?text=Travel+Photography',
        'description': 'Capturing landscapes and travel adventures.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// NAVIGATION BAR (simplified)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: tColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.camera_alt_rounded, color: Colors.tealAccent, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "Grace Studio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// PAGE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Our Projects",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Here are some of the latest photography and videography projects by Grace Studio.",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// PROJECT CARDS
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return ProjectCard(
                        title: project['title']!,
                        description: project['description']!,
                        imageUrl: project['image']!,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const ProjectCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final Color tColor = Color(0xFF1ABC9C);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// TITLE & DESCRIPTION
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: tColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
