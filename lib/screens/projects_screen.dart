import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color tColor = const Color(0xFF6D28D9);
    final Color neonPink = const Color(0xFFEC4899);

    final List<Map<String, String>> projects = [
      {
        'title': 'Wedding Photography',
        'image': 'assets/images/marriage1.jpg',
        'description':
        'Elegant and emotional wedding moments captured forever.\nPreserving timeless memories that tell your love story.'
      },
      {
        'title': 'Corporate Events',
        'image': 'assets/images/corporate_event.webp',
        'description':
        'Professional photography for business conferences.\nEnhancing corporate identity through high-quality visuals.'
      },
      {
        'title': 'Travel Photography',
        'image': 'assets/images/travel.jpg',
        'description':
        'Breathtaking travel destinations and landscapes.\nShowcasing cultures, adventures, and scenic beauty.'
      },
      {
        'title': 'Birthday Events',
        'image': 'assets/images/birthday.jpg',
        'description':
        'Joyful birthday celebrations with beautiful moments.\nCapturing fun, laughter, and special memories.'
      },
      {
        'title': 'Nature Photography',
        'image': 'assets/images/nature.jpg',
        'description':
        'Rich and realistic nature photography.\nHighlighting the beauty of landscapes and wildlife.'
      },
      {
        'title': 'Product Photography',
        'image': 'assets/images/product.webp',
        'description':
        'Clean and professional product visuals.\nDesigned to attract customers and boost brand value.'
      },
      {
        'title': 'Baby Photography',
        'image': 'assets/images/baby.jpg',
        'description':
        'Cute and heart-warming baby photoshoots.\nPreserving precious early-life moments forever.'
      },
      {
        'title': 'Drone Shoots',
        'image': 'assets/images/city1.jpg',
        'description':
        'Cinematic aerial photography using drones.\nOffering stunning perspectives and dynamic visuals.'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0615), // darker purple-black
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Our Portfolio",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Crafted moments, timeless stories",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 35),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 1.5,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ProjectCard(
                  title: project['title']!,
                  description: project['description']!,
                  imagePath: project['image']!,
                  themeColor: index.isEven ? tColor : neonPink,
                  delay: index * 120,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color themeColor;
  final int delay;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.themeColor,
    required this.delay,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedScale(
            scale: _hovered ? 1.04 : 1,
            duration: const Duration(milliseconds: 250),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: const Color(0xFF140F22), // purple-tinted card
                boxShadow: [
                  BoxShadow(
                    color: widget.themeColor
                        .withOpacity(_hovered ? 0.4 : 0.15),
                    blurRadius: _hovered ? 32 : 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(22)),
                          child: Image.asset(
                            widget.imagePath,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(22)),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: widget.themeColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
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
    );
  }
}
