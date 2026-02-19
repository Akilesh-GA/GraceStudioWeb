import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_applications_page.dart';
import 'admin_bookings_screen.dart';
import 'package:grace_studio/screens/login_screen.dart';
import 'admin_qr_screen.dart';
import 'admin_dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_portfolio_screen.dart';

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

  final List<String> adminMenuItems = [
    "QR",
    "Portfolio",
    "Bookings",
    "Applications",
    "Dashboard",
  ];

  final List<String> images = [
    "assets/images/nature.jpg",
    "assets/images/img2.jpg",
    "assets/images/city1.jpg",
    "assets/images/birthday1.jpg",
    "assets/images/wedding.jpg",
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

  void _navigateTo(String page) {
    Widget? screen;

    switch (page) {
      case "QR":
        screen = const AdminQRScreen();
        break;
      case "Portfolio":
        screen = const ProjectsScreen();
        break;
      case "Bookings":
        screen = const AdminBookingsScreen();
        break;
      case "Dashboard":
        screen = const AdminDashboardScreen();
        break;
      case "Applications":
        screen = const AdminApplicationsScreen();
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

            /// HERO SECTION
            SizedBox(
              height: screenHeight,
              child: Stack(
                children: [

                  // Background slider
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

                  /// ADMIN NAVBAR (no box)
                  Positioned(
                    top: 30,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        /// LOGO
                        Text(
                          "Grace Studio",
                          style: GoogleFonts.montserrat(
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
                                    style: GoogleFonts.montserrat(
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

                  /// ADMIN TITLE
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Admin Control Panel",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Manage bookings • QR • notifications • applications",
                          style: GoogleFonts.poppins(
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

            /// FOOTER
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
