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
  final Color bgDark = const Color(0xFF0A0615);
  final Color cardBlack = const Color(0xFF14141C);

  // --- PRIVILEGE: DELETE ---
  void _deleteProject(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBlack,
        title: const Text("Delete Project?", style: TextStyle(color: Colors.white)),
        content: const Text("This action cannot be undone.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => PortfolioData.projects.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- PRIVILEGE: ADD / EDIT DIALOG ---
  void _showProjectDialog({int? index}) {
    final isEditing = index != null;
    final titleController = TextEditingController(text: isEditing ? PortfolioData.projects[index]['title'] : "");
    final descController = TextEditingController(text: isEditing ? PortfolioData.projects[index]['description'] : "");
    final driveController = TextEditingController(text: isEditing ? PortfolioData.projects[index]['drive'] : "");
    final imageController = TextEditingController(text: isEditing ? PortfolioData.projects[index]['image'] : "assets/images/nature.jpg");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEditing ? "Edit Project" : "Add New Project", style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAdminTextField(titleController, "Project Title"),
              const SizedBox(height: 12),
              _buildAdminTextField(descController, "Description", maxLines: 3),
              const SizedBox(height: 12),
              _buildAdminTextField(driveController, "Drive Link"),
              const SizedBox(height: 12),
              _buildAdminTextField(imageController, "Image Path (Asset)"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: neonPink),
            onPressed: () {
              final newData = {
                'title': titleController.text,
                'description': descController.text,
                'drive': driveController.text,
                'image': imageController.text,
              };
              setState(() {
                if (isEditing) {
                  PortfolioData.projects[index] = newData;
                } else {
                  PortfolioData.projects.add(newData);
                }
              });
              Navigator.pop(context);
            },
            child: Text(isEditing ? "Update" : "Create"),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30),
        filled: true,
        fillColor: bgDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioData.projects;

    return Scaffold(
      backgroundColor: bgDark,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: neonPink,
        onPressed: () => _showProjectDialog(),
        icon: const Icon(Icons.add),
        label: const Text("Add Project"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Admin Management",
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "Modify or add portfolio entries",
              style: TextStyle(fontSize: 16, color: Colors.white54),
            ),
            const SizedBox(height: 35),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                childAspectRatio: 1.4,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: (index.isEven ? tColor : neonPink).withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(child: Image.asset(project['image']!, fit: BoxFit.cover)),

                        // Gradient Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.9)],
                              ),
                            ),
                          ),
                        ),

                        // Admin Controls (Top Right)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black54,
                                child: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                                  onPressed: () => _showProjectDialog(index: index),
                                ),
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.black54,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                                  onPressed: () => _deleteProject(index),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content Display
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project['title']!,
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                project['description']!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
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