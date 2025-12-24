import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 🎨 STUDIO THEME COLORS
const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF7B2EFF);
const Color neonPink = Color(0xFFFF2FB3);
const Color cardBlack = Color(0xFF14141C);
const Color textGrey = Color(0xFFB0B0C3);

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final serviceController = TextEditingController();
  final dateController = TextEditingController();
  final messageController = TextEditingController();

  String errorMessage = "";

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
    phoneController.dispose();
    serviceController.dispose();
    dateController.dispose();
    messageController.dispose();
    super.dispose();
  }

  /// Date Picker Logic
  /// Date Picker Logic (Dark Neon Theme)
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: neonPink,       // Header & selected date color
              onPrimary: Colors.white, // Text on selected date
              onSurface: Colors.white, // Text for other dates
            ),
            dialogBackgroundColor: cardBlack, // Calendar background
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: neonPink), // Buttons
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dateController.text =
      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
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
                          const SizedBox(height: 20),
                          const Text(
                            "Book a Service",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Fill details to confirm your booking",
                            style: TextStyle(fontSize: 16, color: textGrey),
                          ),
                          const SizedBox(height: 40),

                          // Card
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
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                BookingInputField(
                                  controller: nameController,
                                  label: "Name",
                                  icon: Icons.person_outline,
                                ),
                                const SizedBox(height: 18),
                                BookingInputField(
                                  controller: emailController,
                                  label: "Email",
                                  icon: Icons.email_outlined,
                                ),
                                const SizedBox(height: 18),
                                BookingInputField(
                                  controller: phoneController,
                                  label: "Phone Number",
                                  icon: Icons.phone_outlined,
                                ),
                                const SizedBox(height: 18),
                                BookingInputField(
                                  controller: serviceController,
                                  label: "Service (Photography / Videography)",
                                  icon: Icons.camera_alt_outlined,
                                ),
                                const SizedBox(height: 18),

                                // Date Picker Field
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: BookingInputField(
                                      controller: dateController,
                                      label: "Preferred Date",
                                      icon: Icons.calendar_today_outlined,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                BookingInputField(
                                  controller: messageController,
                                  label: "Additional Details",
                                  icon: Icons.notes_outlined,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 10),

                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                const SizedBox(height: 20),

                                // Submit Button
                                GestureDetector(
                                  onTap: _submitBooking,
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
                                        "Submit Booking",
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
                          const SizedBox(height: 20),
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

  /// Firebase Booking Logic
  Future<void> _submitBooking() async {
    setState(() => errorMessage = "");

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => errorMessage = "Please login to book a service");
      return;
    }

    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        serviceController.text.isEmpty ||
        dateController.text.isEmpty) {
      setState(() => errorMessage = "Please fill all required fields");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection("bookings").add({
        "userId": user.uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "service": serviceController.text.trim(),
        "preferredDate": dateController.text.trim(),
        "message": messageController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
        "status": "pending",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking submitted successfully")),
      );

      nameController.clear();
      phoneController.clear();
      serviceController.clear();
      dateController.clear();
      messageController.clear();
    } catch (e) {
      setState(() => errorMessage = "Failed to submit booking");
    }
  }
}

class BookingInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const BookingInputField({
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
          border: InputBorder.none, // removed underline
        ),
      ),
    );
  }
}
