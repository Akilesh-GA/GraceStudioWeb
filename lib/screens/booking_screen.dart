import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
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

  final Color tColor = Color(0xFF1ABC9C);

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
    phoneController.dispose();
    serviceController.dispose();
    dateController.dispose();
    messageController.dispose();
    super.dispose();
  }

  /// 📅 Date Picker Logic (NO business logic change)
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // prevent past dates
      lastDate: DateTime(DateTime.now().year + 2),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1ABC9C), // header + selected date
              onPrimary: Colors.white,   // text on header
              onSurface: Colors.black,   // calendar text
            ),
            dialogBackgroundColor: Colors.white,
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(
                position: slideAnim,
                child: Column(
                  children: [
                    Text(
                      "Book a Service",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Fill details to confirm your booking",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 30),

                    /// CARD
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
                          BookingInputField(
                            controller: nameController,
                            label: "Name",
                            icon: Icons.person_outline,
                          ),
                          SizedBox(height: 18),

                          BookingInputField(
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                          ),
                          SizedBox(height: 18),

                          BookingInputField(
                            controller: phoneController,
                            label: "Phone Number",
                            icon: Icons.phone_outlined,
                          ),
                          SizedBox(height: 18),

                          BookingInputField(
                            controller: serviceController,
                            label: "Service (Photography / Videography)",
                            icon: Icons.camera_alt_outlined,
                          ),
                          SizedBox(height: 18),

                          /// 📅 DATE FIELD (Calendar Picker)
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
                          SizedBox(height: 18),

                          BookingInputField(
                            controller: messageController,
                            label: "Additional Details",
                            icon: Icons.notes_outlined,
                            maxLines: 4,
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

                          /// SUBMIT BUTTON
                          GestureDetector(
                            onTap: _submitBooking,
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: tColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 FIREBASE BOOKING LOGIC (UNCHANGED)
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
        SnackBar(content: Text("Booking submitted successfully")),
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

/// INPUT FIELD (UI UNCHANGED)
class BookingInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const BookingInputField({
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
