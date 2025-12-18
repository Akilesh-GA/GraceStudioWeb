import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'projects_screen.dart';
import 'contact_screen.dart';
import 'booking_screen.dart';
import 'joinus_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _hoveredItem = '';

  final List<String> menuItems = [
    "About",
    "Projects",
    "Contact Us",
    "Booking",
    "Join Us",
  ];

  void _navigateTo(String page) {
    Widget targetPage;
    switch (page) {
      case "About":
        targetPage = const AboutScreen();
        break;
      case "Projects":
        targetPage = const ProjectsScreen();
        break;
      case "Contact Us":
        targetPage = const ContactUsScreen();
        break;
      case "Booking":
        targetPage = BookingScreen();
        break;
      case "Join Us":
        targetPage = JoinUsScreen();
        break;
      default:
        targetPage = const HomeScreen();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// NAVIGATION BAR
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.tealAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LOGO
                Row(
                  children: const [
                    Icon(Icons.camera_alt_rounded,
                        color: Colors.tealAccent, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "Grace Studio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),

                /// MENU ITEMS
                Row(
                  children: menuItems.map((item) {
                    bool isHovered = _hoveredItem == item;
                    return MouseRegion(
                      onEnter: (_) => setState(() => _hoveredItem = item),
                      onExit: (_) => setState(() => _hoveredItem = ''),
                      child: GestureDetector(
                        onTap: () => _navigateTo(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  color: isHovered
                                      ? Colors.tealAccent
                                      : Colors.white70,
                                  fontSize: 18,
                                  fontWeight: isHovered
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                              /// Animated underline only
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                height: 3,
                                width: isHovered ? 30 : 0,
                                margin: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  color: Colors.tealAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          /// PAGE BODY
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Welcome to Grace Studio",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Photography • Videography • Events • Portfolio Creation",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
