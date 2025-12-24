import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// 🎨 STUDIO THEME COLORS
const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF7B2EFF);
const Color neonPink = Color(0xFFFF2FB3);
const Color cardBlack = Color(0xFF14141C);
const Color textGrey = Color(0xFFB0B0C3);

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final serviceController = TextEditingController();
  final dateController = TextEditingController();
  final messageController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  late Razorpay _razorpay;
  int bookingAmount = 0;

  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    /// Animations
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

    _controller.forward();

    /// Razorpay Init
    _razorpay = Razorpay();
    _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    /// Auto-fill email
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailController.text = user.email ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _razorpay.clear();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    serviceController.dispose();
    dateController.dispose();
    messageController.dispose();
    super.dispose();
  }

  /// 📅 Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: neonPink,
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: cardBlack,
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

  /// 💰 Ask Amount Dialog
  Future<void> _askAmountAndPay() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        serviceController.text.isEmpty ||
        dateController.text.isEmpty) {
      setState(() => errorMessage = "Please fill all required fields");
      return;
    }

    final TextEditingController amountController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardBlack,
        title: const Text(
          "Enter Amount",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Amount in ₹",
            hintStyle: TextStyle(color: textGrey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
            const Text("Cancel", style: TextStyle(color: neonPink)),
          ),
          TextButton(
            onPressed: () {
              bookingAmount = int.parse(amountController.text);
              Navigator.pop(context);
              _openPaymentGateway();
            },
            child:
            const Text("Pay", style: TextStyle(color: neonPink)),
          ),
        ],
      ),
    );
  }

  /// 💳 Open Razorpay
  void _openPaymentGateway() {
    var options = {
      'key': 'rzp_test_XXXXXXXXXXXXXXXX', // 🔑 TEST KEY
      'amount': bookingAmount * 100,
      'name': 'Grace Studio',
      'description': 'Service Booking Payment',
      'prefill': {
        'contact': phoneController.text,
        'email': emailController.text,
      },
      'theme': {'color': '#FF2FB3'},
    };

    _razorpay.open(options);
  }

  /// ✅ Payment Success
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _saveBooking(response.paymentId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Payment Successful & Booking Confirmed")),
    );
  }

  /// ❌ Payment Failed
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed")),
    );
  }

  /// 🔥 Save Booking to Firebase
  Future<void> _saveBooking(String? paymentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("bookings").add({
      "userId": user.uid,
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "service": serviceController.text.trim(),
      "preferredDate": dateController.text.trim(),
      "message": messageController.text.trim(),
      "amount": bookingAmount,
      "paymentId": paymentId,
      "paymentStatus": "Paid",
      "status": "confirmed",
      "createdAt": FieldValue.serverTimestamp(),
    });

    nameController.clear();
    phoneController.clear();
    serviceController.clear();
    dateController.clear();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Book a Service",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  /// CARD
                  Container(
                    width: 340,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: cardBlack,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 30,
                          color: neonPink.withOpacity(0.25),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        BookingInputField(
                            controller: nameController,
                            label: "Name",
                            icon: Icons.person),
                        const SizedBox(height: 15),
                        BookingInputField(
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email),
                        const SizedBox(height: 15),
                        BookingInputField(
                            controller: phoneController,
                            label: "Phone",
                            icon: Icons.phone),
                        const SizedBox(height: 15),
                        BookingInputField(
                            controller: serviceController,
                            label: "Service",
                            icon: Icons.camera_alt),
                        const SizedBox(height: 15),

                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: BookingInputField(
                                controller: dateController,
                                label: "Preferred Date",
                                icon: Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 15),
                        BookingInputField(
                          controller: messageController,
                          label: "Additional Details",
                          icon: Icons.notes,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: _askAmountAndPay,
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [purple, neonPink]),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Submit & Pay",
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
  }
}

/// 🔹 Input Field Widget
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
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textGrey),
        prefixIcon: Icon(icon, color: neonPink),
        border: InputBorder.none,
      ),
    );
  }
}
