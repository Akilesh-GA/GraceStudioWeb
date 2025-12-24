import 'package:flutter/material.dart';

const Color bgBlack = Color(0xFF0B0B0F);
const Color mapBg = Color(0xFF101018); // UPDATED MAP BACKGROUND
const Color purple = Color(0xFF9D4EDD);
const Color neonPink = Color(0xFFFF2FB3);
const Color textGrey = Color(0xFFB0B0C3);

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  const Text(
                    "About Grace Studio",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// ABOUT
                  const Text(
                    "Grace Studio began as a passion-driven journey rooted in the love for capturing genuine emotions and untold stories through a lens.\n"
                        "Over time, that passion evolved into a creative studio recognized for its authenticity, consistent quality, and the deep trust built with every client.\n"
                        "Our journey continues with a powerful vision to grow, inspire creativity, and preserve timeless memories that will be cherished for generations.",
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  /// MISSION
                  const Text(
                    "Our Mission",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "To create meaningful visuals that capture emotions, preserve memories, and tell stories that last forever.\n"
                        "Driven by passion and creativity, we transform fleeting moments into timeless art.\n"
                        "Every frame we capture reflects our commitment to authenticity, excellence, and storytelling that lives beyond time.",
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  /// MAP TITLE
                  const Text(
                    "Our Journey",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// MAP VIEW (HEIGHT INCREASED)
                  Container(
                    height: 460, // 🔼 increased height
                    decoration: BoxDecoration(
                      color: mapBg,
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          mapBg,
                          mapBg.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        /// ROUTE PATH (ANIMATED GLOW)
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (_, __) {
                              return CustomPaint(
                                painter: JourneyPathPainter(
                                  glow: _controller.value,
                                ),
                              );
                            },
                          ),
                        ),

                        /// MARKERS (UNCHANGED POSITIONS)
                        const Positioned(
                          left: 40,
                          bottom: 80,
                          child: MapMarker(
                            title: "The Beginning",
                            subtitle:
                            "Started in a small photo studio in Tiruppur,\n"
                                "without a name board or recognition—\n"
                                "just a camera, determination, and a dream.",
                            color: neonPink,
                          ),
                        ),

                        const Positioned(
                          left: 360,
                          top: 160,
                          child: MapMarker(
                            title: "Learning",
                            subtitle:
                            "Every shoot became a classroom—\n"
                                "learning lighting, angles, editing,\n"
                                "and storytelling through practice.",
                            color: purple,
                          ),
                        ),

                        const Positioned(
                          left: 650,
                          top: 120,
                          child: MapMarker(
                            title: "Expansion",
                            subtitle:
                            "Services expanded, equipment upgraded,\n"
                                "and a clear vision took shape—\n"
                                "turning passion into identity.",
                            color: neonPink,
                          ),
                        ),

                        const Positioned(
                          left: 920,
                          top: 150,
                          child: MapMarker(
                            title: "Growth",
                            subtitle:
                            "Trust built through consistent quality,\n"
                                "emotional storytelling, and dedication—\n"
                                "clients became long-term family.",
                            color: purple,
                          ),
                        ),

                        const Positioned(
                          right: 40,
                          bottom: 100,
                          child: MapMarker(
                            title: "Destination",
                            subtitle:
                            "Creating timeless visual stories\n"
                                "with a global vision—where every\n"
                                "frame preserves lasting memories.",
                            color: neonPink,
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

/// ================= MAP MARKER =================
class MapMarker extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const MapMarker({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.location_on, size: 36, color: color),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: textGrey,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class JourneyPathPainter extends CustomPainter {
  final double glow;

  JourneyPathPainter({required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = purple.withOpacity(0.4 + glow * 0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(60, size.height - 100);
    path.quadraticBezierTo(
      size.width / 2,
      40,
      size.width - 60,
      size.height - 120,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
