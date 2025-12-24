import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // 🎨 Theme Colors
  final Color purple = const Color(0xFF6D28D9);
  final Color neonPink = const Color(0xFFEC4899);

  final List<String> images = List.generate(
    10,
        (index) => 'assets/images/img${index + 1}.jpg',
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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

    // ⏱ Auto slide
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _currentPage = (_currentPage + 1) % images.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: fadeAnim,
        child: Stack(
          children: [

            // 🔥 FULL SCREEN CAROUSEL
            PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),

            // 🎭 DARK OVERLAY
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),

            // ✨ CONTENT (CENTERED FIX)
            SafeArea(
              child: Center( // ✅ ONLY IMPORTANT CHANGE
                child: SlideTransition(
                  position: slideAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        "Grace Photo Studio",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: neonPink,
                          letterSpacing: 1.3,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "Book shoots • View portfolio • Manage gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // 🔘 Login Button
                      _buildButton(
                        label: "Login",
                        gradient: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      // 🔘 Register Button
                      _buildButton(
                        label: "Create an Account",
                        border: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    bool gradient = false,
    bool border = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55,
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: border ? Border.all(color: neonPink, width: 2) : null,
          gradient: gradient
              ? const LinearGradient(
            colors: [Color(0xFF6D28D9), Color(0xFFEC4899)],
          )
              : null,
          boxShadow: gradient
              ? [
            BoxShadow(
              color: neonPink.withOpacity(0.6),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: border ? neonPink : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
