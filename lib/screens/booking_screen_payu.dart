import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Added for title style
import '../widgets/booking_input_field.dart';
import 'package:payu_in_web/payu_in_web.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF7B2EFF);
const Color neonPink = Color(0xFFFF2FB3);
const Color cardBlack = Color(0xFF14141C);
const Color textGrey = Color(0xFFB0B0C3);

class BookingScreenWeb extends StatefulWidget {
  const BookingScreenWeb({super.key});

  @override
  State<BookingScreenWeb> createState() => _BookingScreenWebState();
}

class _BookingScreenWebState extends State<BookingScreenWeb>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  final dateController = TextEditingController();

  String? selectedService;
  final List<String> services = ["Photography", "Videography", "Editing", "Drone Shoot", "Other"];

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  int bookingAmount = 1; // Test amount
  String errorMessage = "";

  // TEST CREDENTIALS
  final String merchantKey = "ORvXCP";
  final String merchantSalt = "7Sj8I4ITXjyQ5hUS8gBjkamMBKD5ZO3n";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    selectedService = services.first;
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _openPayUWeb() {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || selectedService == null || dateController.text.isEmpty) {
      setState(() => errorMessage = "Please fill all required fields");
      return;
    }

    final String txnId = "TXN${DateTime.now().millisecondsSinceEpoch}";
    final String amount = bookingAmount.toString();
    final String productName = selectedService!;
    final String firstName = nameController.text;
    final String email = emailController.text;

    try {
      FlutterPayuWeb.checkout(
        merchantKey: merchantKey,
        salt: merchantSalt,
        transactionId: txnId,
        amountAsDouble: bookingAmount.toDouble(),
        product: productName,
        firstName: firstName,
        lastName: "",
        email: email,
        phone: phoneController.text,
        sUrl: "https://cbjs.payu.in/sdk/success",
        fUrl: "https://cbjs.payu.in/sdk/failure",
        launchNewTab: true,
      );
    } catch (e) {
      setState(() => errorMessage = "Payment failed to initialize: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(primary: neonPink, onPrimary: Colors.white, onSurface: Colors.white),
          dialogBackgroundColor: cardBlack,
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) {
      dateController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      // AppBar added for brand consistency
      appBar: AppBar(
        backgroundColor: bgBlack,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Grace Studio",
          style: GoogleFonts.greatVibes(fontSize: 28, color: Colors.white70),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main Heading
                    const Text(
                      "Book a Service",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    const Text(
                      "Reserve your slot for a premium creative experience",
                      style: TextStyle(fontSize: 15, color: textGrey, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 35),

                    Container(
                      width: 340,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: cardBlack,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                              color: neonPink.withOpacity(0.15)
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          BookingInputField(controller: nameController, label: "Name", icon: Icons.person),
                          const SizedBox(height: 15),
                          BookingInputField(controller: emailController, label: "Email", icon: Icons.email),
                          const SizedBox(height: 15),
                          BookingInputField(controller: phoneController, label: "Phone", icon: Icons.phone),
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(color: cardBlack, borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonFormField<String>(
                              value: selectedService,
                              dropdownColor: cardBlack,
                              icon: const Icon(Icons.keyboard_arrow_down, color: neonPink),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Service",
                                  labelStyle: TextStyle(color: textGrey)
                              ),
                              style: const TextStyle(color: Colors.white),
                              items: services.map((service) => DropdownMenuItem(value: service, child: Text(service))).toList(),
                              onChanged: (value) => setState(() => selectedService = value),
                            ),
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: BookingInputField(controller: dateController, label: "Preferred Date", icon: Icons.calendar_today),
                            ),
                          ),
                          const SizedBox(height: 15),
                          BookingInputField(controller: messageController, label: "Additional Details", icon: Icons.notes, maxLines: 3),
                          const SizedBox(height: 25),
                          GestureDetector(
                            onTap: _openPayUWeb,
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [purple, neonPink]),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: neonPink.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    )
                                  ]
                              ),
                              child: const Center(
                                child: Text(
                                    "Submit & Pay",
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                          ),
                          if (errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 15),
                            Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.redAccent, fontSize: 13)
                            ),
                          ]
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
}