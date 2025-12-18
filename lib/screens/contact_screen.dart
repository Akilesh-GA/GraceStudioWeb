import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color tColor = Color(0xFF1ABC9C);

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();

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
                  Text(
                    "Contact Us",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Have questions or want to book a session? Fill out the form below or reach out to us via email or phone.",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// CONTACT FORM
                  ContactInputField(controller: nameController, label: "Full Name"),
                  const SizedBox(height: 18),
                  ContactInputField(controller: emailController, label: "Email"),
                  const SizedBox(height: 18),
                  ContactInputField(controller: messageController, label: "Message", maxLines: 5),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Connect to backend or email service
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message sent! (Demo)')),
                      );
                      nameController.clear();
                      emailController.clear();
                      messageController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Send Message",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 50),

                  /// CONTACT DETAILS
                  Text(
                    "Get in Touch",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ContactDetailRow(
                    icon: Icons.location_on_outlined,
                    text: "123 Studio Lane, City, Country",
                  ),
                  ContactDetailRow(
                    icon: Icons.email_outlined,
                    text: "info@gracestudio.com",
                  ),
                  ContactDetailRow(
                    icon: Icons.phone_outlined,
                    text: "+91 98765 43210",
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

class ContactInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const ContactInputField({
    required this.controller,
    required this.label,
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
        prefixIcon: Icon(Icons.edit_outlined, color: tColor),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tColor.withOpacity(0.5), width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}

class ContactDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactDetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
