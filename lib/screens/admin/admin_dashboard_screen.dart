import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Color Palette
const Color bgBlack = Color(0xFF050507);
const Color purple = Color(0xFF7B2CBF);
const Color neonPink = Color(0xFFFF006E);
const Color textGrey = Color(0xFF8E8E93);
const Color glassBorder = Colors.white12;

class AdminWebDashboard extends StatefulWidget {
  const AdminWebDashboard({super.key});

  @override
  State<AdminWebDashboard> createState() => _AdminWebDashboardState();
}

class _AdminWebDashboardState extends State<AdminWebDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: Stack(
        children: [
          // Background Depth Glows
          Positioned(top: -100, left: -50, child: _Glow(purple)),
          Positioned(bottom: -100, right: -50, child: _Glow(neonPink)),

          Row(
            children: [
              /// 1. FIXED SIDEBAR

              /// 2. SCROLLABLE CONTENT AREA
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildMainGlassWrapper(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 40),

                          /// RESPONSIVE STATS GRID
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: const [
                              _StatCard("Total Users", "1,248", Icons.people_outline, purple),
                              _StatCard("Bookings", "326", Icons.auto_awesome_outlined, neonPink),
                              _StatCard("Revenue", "₹4.2L", Icons.payments_outlined, Colors.blueAccent),
                              _StatCard("System Health", "99.9%", Icons.bolt_rounded, Colors.greenAccent),
                            ],
                          ),

                          const SizedBox(height: 48),
                          const Text(
                            "Platform Analytics",
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 24),

                          /// RESPONSIVE ANALYTICS SECTION
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth < 900) {
                                // Stack vertically on smaller screens to prevent overflow
                                return Column(
                                  children: const [
                                    _PieChartCard(height: 400),
                                    SizedBox(height: 24),
                                    _InsightsCard(height: 400),
                                  ],
                                );
                              }
                              // Side-by-side on wide screens
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Expanded(flex: 3, child: _PieChartCard(height: 400)),
                                  SizedBox(width: 24),
                                  Expanded(flex: 2, child: _InsightsCard(height: 400)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? neonPink : textGrey, size: 22),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : textGrey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Admin Overview", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
            Text("Real-time operational metrics", style: TextStyle(color: textGrey, fontSize: 14)),
          ],
        ),
        const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white12,
          child: Icon(Icons.person_outline, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildMainGlassWrapper({required Widget child}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: glassBorder),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.04), Colors.white.withOpacity(0.01)],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color accentColor;
  const _StatCard(this.title, this.value, this.icon, this.accentColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 28),
          const SizedBox(height: 24),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: textGrey, fontSize: 14)),
        ],
      ),
    );
  }
}

class _PieChartCard extends StatelessWidget {
  final double height;
  const _PieChartCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Distribution", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 60,
                sectionsSpace: 8,
                sections: [
                  PieChartSectionData(value: 40, color: purple, radius: 50, title: "40%", titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                  PieChartSectionData(value: 30, color: neonPink, radius: 50, title: "30%", titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                  PieChartSectionData(value: 30, color: Colors.blueAccent, radius: 50, title: "30%", titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  final double height;
  const _InsightsCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Insights", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                _insightRow("📈 Revenue up 12% this month"),
                _insightRow("🔥 14 New Bookings today"),
                _insightRow("⚡ 99.9% Server Uptime"),
                _insightRow("⭐ 4.9 Avg User Rating"),
                _insightRow("⏳ Approval time down 15%"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          const CircleAvatar(radius: 3, backgroundColor: neonPink),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: textGrey, fontSize: 15))),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  const _Glow(this.color);
  @override
  Widget build(BuildContext context) => CircleAvatar(radius: 200, backgroundColor: color.withOpacity(0.06));
}