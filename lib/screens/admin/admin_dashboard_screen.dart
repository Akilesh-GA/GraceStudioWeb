import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Color Palette - Luxury Dark Theme
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
              /// 1. PROFESSIONAL SIDEBAR
              _buildSidebar(),

              /// 2. CONTENT AREA
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildMainGlassWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 40),

                        /// STATS WRAP (Responsive Grid)
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

                        /// ANALYTICS SECTION
                        Expanded(
                          child: Row(
                            children: const [
                              Expanded(flex: 3, child: _PieChartCard()),
                              SizedBox(width: 24),
                              Expanded(flex: 2, child: _InsightsCard()),
                            ],
                          ),
                        ),
                      ],
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

  /// SIDEBAR WIDGET
  Widget _buildSidebar() {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45, width: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [purple, neonPink]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_fix_high_rounded, color: Colors.white),
              ),
              const SizedBox(width: 15),
              const Text("LENS PRO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 2)),
            ],
          ),
          const SizedBox(height: 60),
          _navItem(0, Icons.grid_view_rounded, "Dashboard"),
          _navItem(1, Icons.qr_code_2_rounded, "QR Manager"),
          _navItem(2, Icons.analytics_outlined, "Reports"),
          _navItem(3, Icons.settings_outlined, "Settings"),
          const Spacer(),
          _navItem(4, Icons.logout_rounded, "Sign Out"),
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
            Text("Real-time data from your photography portal", style: TextStyle(color: textGrey, fontSize: 14)),
          ],
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.05),
          child: const Icon(Icons.person_outline, color: Colors.white),
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

/// STAT CARD WIDGET
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

/// PIE CHART CARD
class _PieChartCard extends StatelessWidget {
  const _PieChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SizedBox(height: 40),
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

/// INSIGHTS CARD
class _InsightsCard extends StatelessWidget {
  const _InsightsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _insightRow("📈 Revenue up 12%"),
          _insightRow("🔥 14 New Bookings"),
          _insightRow("⚡ 99.9% Server Uptime"),
          _insightRow("⭐ 4.9 Avg Rating"),
        ],
      ),
    );
  }

  Widget _insightRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(text, style: const TextStyle(color: textGrey, fontSize: 15)),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  const _Glow(this.color);
  @override
  Widget build(BuildContext context) => CircleAvatar(radius: 200, backgroundColor: color.withOpacity(0.06));
}