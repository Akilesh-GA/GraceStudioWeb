import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'joinus_screen.dart';
import 'projects_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_screen_payu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentPage = 0;
  String _hoveredItem = "";

  final List<String> menuItems = [
    "About",
    "Portfolio",
    "Contact Us",
    "Booking",
    "Join Us",
  ];

  final List<String> images = [
    "assets/images/nature.jpg",
    "assets/images/img2.jpg",
    "assets/images/city1.jpg",
    "assets/images/birthday1.jpg",
    "assets/images/wedding.jpg",
  ];

  Timer? _timer;

  // Shimmer animation controller
  late final AnimationController _shineController;
  late final Animation<double> _shineAnim;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _currentPage = (_currentPage + 1) % images.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutCubic,
      );
    });

    // Initialize shimmer animation safely
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shineAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateTo(String page) {
    Widget? screen;

    switch (page) {
      case "About":
        screen = const AboutScreen();
        break;
      case "Portfolio":
        screen = const ProjectsScreen();
        break;
      case "Contact Us":
        screen = const ContactUsScreen();
        break;
      case "Booking":
        screen = const BookingScreenWeb();
        break;
      case "Join Us":
        screen = JoinUsScreen();
        break;
    }

    if (screen != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => screen!,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.2, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight,
              child: Stack(
                children: [
                  // Background slider
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Nav bar (no box effect)
                  Positioned(
                    top: 30,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Grace Studio",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: menuItems.map((item) {
                            final isHovered = _hoveredItem == item;
                            return MouseRegion(
                              onEnter: (_) => setState(() => _hoveredItem = item),
                              onExit: (_) => setState(() => _hoveredItem = ""),
                              child: GestureDetector(
                                onTap: () => _navigateTo(item),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(horizontal: 14),
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isHovered
                                            ? const Color(0xFF9D4EDD)
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: isHovered
                                          ? const Color(0xFFFF2EC4)
                                          : Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        GestureDetector(
                          onTap: _logout,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF7B2EFF),
                                  Color(0xFFFF2EC4),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFF2EC4).withOpacity(0.55),
                                  blurRadius: 25,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.logout, size: 18, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center title with shimmer
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _shineAnim,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: const [
                                    Color(0xFFFFFFFF),
                                    Color(0xFFEC4899),
                                    Color(0xFFFFFFFF)
                                  ],
                                  stops: [
                                    (_shineAnim.value - 0.3).clamp(0.0, 1.0),
                                    _shineAnim.value.clamp(0.0, 1.0),
                                    (_shineAnim.value + 0.3).clamp(0.0, 1.0)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(
                                    Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                              },
                              child: Text(
                                "Welcome to Grace Studio",
                                style: GoogleFonts.greatVibes(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Wedding • Portrait • Events • Cinematic Shoots",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50),
              color: Colors.black,
              child: Column(
                children: [
                  const Text(
                    "Grace Studio",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(FontAwesomeIcons.facebook),
                      _socialIcon(FontAwesomeIcons.instagram),
                      _socialIcon(FontAwesomeIcons.twitter),
                      _socialIcon(FontAwesomeIcons.youtube),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "© 2025 Grace Studio. All Rights Reserved",
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFF2EC4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D4EDD).withOpacity(0.6),
            blurRadius: 12,
          ),
        ],
      ),
      child: FaIcon(
        icon,
        color: const Color(0xFFFF2EC4),
        size: 18,
      ),
    );
  }
}
