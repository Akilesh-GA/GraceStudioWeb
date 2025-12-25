import 'dart:js' as js;
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  /// Razorpay Web Checkout
  void _openRazorpayWeb(BuildContext context) {
    final options = {
      'key': 'rzp_test_RvvN9GKGLnVUym', // 🔴 Replace with your TEST KEY
      'amount': 100, // ₹1 = 100 paise
      'currency': 'INR',
      'name': 'Grace Studio',
      'description': 'Slot Booking Payment',
      'image': 'https://your-logo-url.png', // optional
      'prefill': {
        'contact': '9999999999',
        'email': 'test@email.com',
      },
      'handler': js.allowInterop((response) {
        final paymentId = response['razorpay_payment_id'];
        debugPrint("✅ Payment Success: $paymentId");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful\nID: $paymentId")),
        );

        // TODO: Save paymentId to Firebase if needed
      }),
      'modal': {
        'ondismiss': js.allowInterop(() {
          debugPrint("❌ Payment Cancelled");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment Cancelled")),
          );
        })
      }
    };

    final razorpay = js.context.callMethod(
      'Razorpay',
      [js.JsObject.jsify(options)],
    );

    razorpay.callMethod('open');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Slot Booking"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _openRazorpayWeb(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
          ),
          child: const Text(
            "Pay ₹1",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
