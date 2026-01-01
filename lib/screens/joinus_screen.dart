import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF7B2EFF);
const Color neonPink = Color(0xFFFF2FB3);
const Color cardBlack = Color(0xFF14141C);
const Color textGrey = Color(0xFFB0B0C3);

class JoinUsScreen extends StatefulWidget {
  const JoinUsScreen({super.key});

  @override
  _JoinUsScreenState createState() => _JoinUsScreenState();
}

class _JoinUsScreenState extends State<JoinUsScreen>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final messageController = TextEditingController();

  String errorMessage = "";
  PlatformFile? selectedResume;

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailController.text = user.email ?? "";
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: FadeTransition(
                    opacity: fadeAnim,
                    child: SlideTransition(
                      position: slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Join Us",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Become a part of Grace Studio's creative team",
                            style: TextStyle(fontSize: 16, color: textGrey),
                          ),
                          const SizedBox(height: 40),

                          Container(
                            width: 340,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: cardBlack,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                  color: neonPink.withOpacity(0.25),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                JoinInputField(
                                  controller: nameController,
                                  label: "Full Name",
                                  icon: Icons.person_outline,
                                ),
                                const SizedBox(height: 18),
                                JoinInputField(
                                  controller: emailController,
                                  label: "Email",
                                  icon: Icons.email_outlined,
                                ),
                                const SizedBox(height: 18),
                                JoinInputField(
                                  controller: roleController,
                                  label: "Role (Photographer, Videographer, etc.)",
                                  icon: Icons.work_outline,
                                ),
                                const SizedBox(height: 18),
                                JoinInputField(
                                  controller: messageController,
                                  label: "Tell us about yourself",
                                  icon: Icons.message_outlined,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 18),

                                GestureDetector(
                                  onTap: _pickResume,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: cardBlack,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: neonPink, width: 1.5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.upload_file, color: neonPink),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            selectedResume != null
                                                ? selectedResume!.name
                                                : "Upload Resume (PDF)",
                                            style: const TextStyle(
                                                fontSize: 16, color: Colors.white),
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward_ios,
                                            size: 16, color: neonPink),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                const SizedBox(height: 20),

                                GestureDetector(
                                  onTap: _submitJoinRequest,
                                  child: Container(
                                    height: 55,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                        colors: [purple, neonPink],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Apply Now",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedResume = result.files.first;
      });
    }
  }

  Future<void> _submitJoinRequest() async {
    setState(() => errorMessage = "");

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => errorMessage = "Please login to submit your application");
      return;
    }

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        roleController.text.isEmpty ||
        selectedResume == null) {
      setState(() => errorMessage =
      "Please fill all required fields and upload your resume");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection("join_requests").add({
        "userId": user.uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "role": roleController.text.trim(),
        "message": messageController.text.trim(),
        "resumeFileName": selectedResume!.name,
        "createdAt": FieldValue.serverTimestamp(),
        "status": "pending",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Application submitted successfully")),
      );

      nameController.clear();
      emailController.clear();
      roleController.clear();
      messageController.clear();
      setState(() => selectedResume = null);
    } catch (e) {
      setState(() => errorMessage = "Failed to submit application");
    }
  }
}

class JoinInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const JoinInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        cursorColor: neonPink,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: textGrey),
          prefixIcon: Icon(icon, color: neonPink),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
