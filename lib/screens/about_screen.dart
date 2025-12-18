import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color tColor = Color(0xFF1ABC9C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// NAVIGATION BAR (simplified for About page)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: tColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.camera_alt_rounded, color: Colors.tealAccent, size: 28),
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
                // You can reuse your hover nav items here
              ],
            ),
          ),

          /// PAGE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Grace Studio",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Grace Studio is a premier photography and videography studio dedicated to capturing your most precious moments. "
                        "Our team of professional photographers and videographers specialize in weddings, events, portraits, and creative projects. "
                        "We blend artistic vision with state-of-the-art equipment to ensure every shot tells a story.",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Our Mission",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Our mission is to preserve memories with creativity and professionalism. "
                        "We strive to deliver exceptional quality and personalized service for every client.",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Our Services",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ServiceTile(title: "Wedding Photography"),
                      ServiceTile(title: "Event Videography"),
                      ServiceTile(title: "Portrait Sessions"),
                      ServiceTile(title: "Commercial & Portfolio Shoots"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String title;
  const ServiceTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.tealAccent),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
