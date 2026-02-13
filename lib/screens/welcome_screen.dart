import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  late AnimationController _shineController;
  late Animation<double> _shineAnim;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final Color neonPink = const Color(0xFFEC4899);

  final List<String> images = [
    "assets/images/nature.jpg",
    "assets/images/img2.jpg",
    "assets/images/city1.jpg",
    "assets/images/birthday1.jpg",
    "assets/images/wedding.jpg",
  ];

  @override
  void initState() {
    super.initState();

    // Fade animation for screen
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    // Shine animation for title
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
    _shineAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.linear),
    );

    // Background slider timer
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
    _fadeController.dispose();
    _shineController.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            // Background slider
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

            // Gradient overlay
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

            // Content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Shiny title with Google Font
                    AnimatedBuilder(
                      animation: _shineAnim,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: const [
                                Colors.white70,
                                Colors.white,
                                Colors.white70
                              ],
                              stops: [
                                _shineAnim.value - 0.3,
                                _shineAnim.value,
                                _shineAnim.value + 0.3
                              ],
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            );
                          },
                          child: Text(
                            "Grace Studio",
                            style: GoogleFonts.greatVibes(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Elegance in Every Frame",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 60),

                    _buildButton(
                      label: "Login",
                      gradient: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildButton(
                      label: "Create an Account",
                      border: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RegisterScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Smaller buttons
  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    bool gradient = false,
    bool border = false,
  }) {
    final Color neonPink = const Color(0xFFEC4899);
    final Color purple = const Color(0xFF6D28D9);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 45, // smaller height
        width: 200, // smaller width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: border ? Border.all(color: neonPink, width: 2) : null,
          gradient: gradient
              ? const LinearGradient(
              colors: [Color(0xFF6D28D9), Color(0xFFEC4899)])
              : null,
          boxShadow: gradient
              ? [
            BoxShadow(
              color: neonPink.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: border ? neonPink : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
