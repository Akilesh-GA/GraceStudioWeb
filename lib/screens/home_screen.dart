import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'joinus_screen.dart';
import 'projects_screen.dart';
import 'dart:ui';
import 'booking_screen_web.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentPage = 0;
  String _hoveredItem = "";

  final List<String> menuItems = [
    "About",
    "Projects",
    "Contact Us",
    "Booking",
    "Join Us",
  ];

  final List<String> images = [
    "assets/images/temple.jpg",
    "assets/images/hills.jpg",
    "assets/images/city1.jpg",
    "assets/images/nature2.jpg",
    "assets/images/marriage1.jpg",
    "assets/images/chennai.jpg",
    "assets/images/img2.jpg",
    "assets/images/img3.jpg",
    "assets/images/monkey.jpg",
  ];

  Timer? _timer;

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
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
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
      case "Projects":
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

                  Positioned(
                    top: 30,
                    left: 20,
                    right: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Row(
                                children: const [
                                  Text(
                                    "Grace Studio",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                                                ? const Color(0xFF9D4EDD)
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
                      ),
                    ),
                  ),

                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Moments That Last Forever",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
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
