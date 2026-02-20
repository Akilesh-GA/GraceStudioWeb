import 'package:flutter/material.dart';
import 'package:grace_studio/models/portfolio_data.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final Color tColor = const Color(0xFF6D28D9);
  final Color neonPink = const Color(0xFFEC4899);

  void _deleteProject(int index) {
    setState(() {
      PortfolioData.projects.removeAt(index);
    });
  }

  void _addProject() {
    setState(() {
      PortfolioData.projects.add({
        'title': 'New Project',
        'image': 'assets/images/nature.jpg',
        'description': 'New project description here.',
        'drive': 'https://drive.google.com/'
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioData.projects;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0615),
      floatingActionButton: FloatingActionButton(
        backgroundColor: neonPink,
        onPressed: _addProject,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Admin Portfolio Panel",
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

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    image: DecorationImage(
                      image: AssetImage(project['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProject(index),
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
