import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:grace_studio/screens/login_screen.dart';
import 'admin_qr_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final PageController _pageController = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentPage = 0;
  String _hoveredItem = "";

  /// 🔹 ADMIN NAV ITEMS
  final List<String> adminMenuItems = [
    "QR",
    "Bookings",
    "Notifications",
    "Applications",
  ];

  final List<String> images = [
    "assets/images/nature.jpg",
    "assets/images/img2.jpg",
    "assets/images/city1.jpg",
    "assets/images/marriage1.jpg",
    "assets/images/birthday.jpg",
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
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  /// 🔹 ADMIN NAVIGATION
  void _navigateTo(String page) {
    Widget? screen;

    switch (page) {
      case "QR":
        screen = const AdminQRScreen();
        break;
      case "Bookings":
        // screen = const AdminBookingsScreen();
        break;
      case "Notifications":
        // screen = const AdminNotificationsScreen();
        break;
      case "Applications":
        // screen = const AdminApplicationsScreen();
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

            /// 🔹 HERO SECTION
            SizedBox(
              height: screenHeight,
              child: Stack(
                children: [

                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    itemBuilder: (_, index) {
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

                  /// 🔹 ADMIN NAVBAR
                  Positioned(
                    top: 30,
                    left: 20,
                    right: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// LOGO
                              const Text(
                                "Grace Studio",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              /// ADMIN MENU
                              Row(
                                children: adminMenuItems.map((item) {
                                  final isHovered = _hoveredItem == item;
                                  return MouseRegion(
                                    onEnter: (_) =>
                                        setState(() => _hoveredItem = item),
                                    onExit: (_) =>
                                        setState(() => _hoveredItem = ""),
                                    child: GestureDetector(
                                      onTap: () => _navigateTo(item),
                                      child: AnimatedContainer(
                                        duration:
                                        const Duration(milliseconds: 250),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
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

                              /// LOGOUT
                              GestureDetector(
                                onTap: _logout,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7B2EFF),
                                        Color(0xFFFF2EC4),
                                      ],
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.logout,
                                          size: 18, color: Colors.white),
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

                  /// 🔹 ADMIN TITLE
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Admin Control Panel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Manage bookings • QR • notifications • applications",
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

            /// 🔹 FOOTER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: const Text(
                "© 2025 Grace Studio Admin Panel",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
