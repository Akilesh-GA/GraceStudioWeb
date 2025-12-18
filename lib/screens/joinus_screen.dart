import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

class JoinUsScreen extends StatefulWidget {
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
  final Color tColor = Color(0xFF1ABC9C);

  PlatformFile? selectedResume;

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    slideAnim = Tween<Offset>(
      begin: Offset(0, 0.2),
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(
                position: slideAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Join Us",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Become a part of Grace Studio's creative team",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 30),

                    // CARD
                    Container(
                      width: 340,
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            offset: Offset(0, 10),
                            color: Colors.black.withOpacity(0.07),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          JoinInputField(
                            controller: nameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                          ),
                          SizedBox(height: 18),

                          JoinInputField(
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                          ),
                          SizedBox(height: 18),

                          JoinInputField(
                            controller: roleController,
                            label: "Role (Photographer, Videographer, etc.)",
                            icon: Icons.work_outline,
                          ),
                          SizedBox(height: 18),

                          JoinInputField(
                            controller: messageController,
                            label: "Tell us about yourself",
                            icon: Icons.message_outlined,
                            maxLines: 4,
                          ),
                          SizedBox(height: 18),

                          // PDF Upload Field
                          GestureDetector(
                            onTap: _pickResume,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: tColor),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.upload_file, color: tColor),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      selectedResume != null
                                          ? selectedResume!.name
                                          : "Upload Resume (PDF)",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 16, color: tColor),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          if (errorMessage.isNotEmpty)
                            Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          SizedBox(height: 20),

                          GestureDetector(
                            onTap: _submitJoinRequest,
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: tColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Apply Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      ),
    );
  }

  // Pick PDF resume
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

  /// 🔥 FIREBASE LOGIC
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
      setState(() => errorMessage = "Please fill all required fields and upload your resume");
      return;
    }

    try {
      // For simplicity, storing only the file name in Firestore.
      // If you want to upload to Firebase Storage, you can replace this part.
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
        SnackBar(content: Text("Application submitted successfully")),
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

/// INPUT FIELD (SAME STYLE AS LOGIN)
class JoinInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const JoinInputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final Color tColor = Color(0xFF1ABC9C);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: tColor,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: tColor),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tColor.withOpacity(0.5), width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tColor, width: 2),
        ),
        contentPadding: EdgeInsets.only(bottom: 5),
      ),
      style: TextStyle(fontSize: 16),
    );
  }
}
