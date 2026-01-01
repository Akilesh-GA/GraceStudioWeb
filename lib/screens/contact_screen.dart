import 'package:flutter/material.dart';

const Color bgBlack = Color(0xFF0B0B0F);
const Color cardBlack = Color(0xFF14141C);
const Color purple = Color(0xFF9D4EDD);
const Color neonPink = Color(0xFFFF2FB3);
const Color textGrey = Color(0xFFB0B0C3);

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();

    return Scaffold(
      backgroundColor: bgBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Get in Touch",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Have questions, ideas, or special moments to capture?\n"
                    "Reach out to Grace Studio and let’s create something timeless together.",
                style: TextStyle(
                  fontSize: 16,
                  color: textGrey,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Our Services",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  ServiceCard(
                    icon: Icons.camera_alt,
                    title: "Photography",
                    description: "We breathe photography. Our team is passionate, young, and creative.",
                  ),
                  SizedBox(width: 70),
                  ServiceCard(
                    icon: Icons.videocam,
                    title: "Video",
                    description: "Cinematic wedding and event videos are our greatest strength.",
                  ),
                  SizedBox(width: 70),
                  ServiceCard(
                    icon: Icons.brush,
                    title: "Editing",
                    description: "Experienced editors delivering industry-standard visual quality.",
                  ),
                  SizedBox(width: 70),
                  ServiceCard(
                    icon: Icons.camera_alt,
                    title: "Drone Photography",
                    description: "capturing breathtaking aerial images and video that tell your story from an unforgettable perspective",
                  ),
                  SizedBox(width: 70),
                  ServiceCard(
                    icon: Icons.camera_alt,
                    title: "Art Works",
                    description: "We live for the art of sculpture. Our team is passionate, young, and creative",
                  ),
                ],
              ),

              const SizedBox(height: 60),

              const Text(
                "Send Us a Message",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: cardBlack,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 35,
                        offset: const Offset(0, 15),
                        color: neonPink.withOpacity(0.25),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ContactInputField(
                        controller: nameController,
                        label: "Full Name",
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 18),

                      ContactInputField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 18),

                      ContactInputField(
                        controller: messageController,
                        label: "Message",
                        icon: Icons.message_outlined,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 30),

                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Message sent! (Demo)"),
                            ),
                          );
                          nameController.clear();
                          emailController.clear();
                          messageController.clear();
                        },
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [purple, neonPink],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: neonPink.withOpacity(0.6),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Send Message",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              const ContactDetailRow(
                icon: Icons.location_on_outlined,
                text:
                "Address : 47, Vijayalakshminagar 2nd Street, Vijayapuram, Tiruppur - 641606.",
              ),
              const ContactDetailRow(
                icon: Icons.email_outlined,
                text: "Email : gracedesigners2014@gmail.com",
              ),
              const ContactDetailRow(
                icon: Icons.phone_outlined,
                text: "Phone : +91 9626360044 | +91 9626360055",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= INPUT FIELD =================
class ContactInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const ContactInputField({
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

/// ================= SERVICE CARD =================
class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [purple, neonPink],
              ),
            ),
            child: Icon(icon, size: 26, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: textGrey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// ================= CONTACT INFO ROW =================
class ContactDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactDetailRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: neonPink),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
