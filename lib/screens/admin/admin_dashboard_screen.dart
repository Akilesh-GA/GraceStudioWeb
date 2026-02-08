import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF9D4EDD);
const Color neonPink = Color(0xFFFF2FB3);
const Color textGrey = Color(0xFFB0B0C3);

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// HEADER
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                            LinearGradient(colors: [purple, neonPink]),
                          ),
                          child: const Text(
                            "A",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Welcome back, Admin",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Dashboard overview & analytics",
                              style: TextStyle(color: textGrey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// STAT CARDS
                    Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: const [
                        _StatCard("Total Users", "1,248", Icons.people),
                        _StatCard("Bookings", "326", Icons.calendar_month),
                        _StatCard("Revenue", "₹4.2L", Icons.payments),
                        _StatCard("Pending", "18", Icons.pending_actions),
                      ],
                    ),

                    const SizedBox(height: 36),

                    /// ANALYTICS TITLE
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          const LinearGradient(colors: [purple, neonPink])
                              .createShader(bounds),
                      child: const Text(
                        "Platform Analytics",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PIE + INSIGHTS (FIXED)
                    Expanded(
                      child: Row(
                        children: const [
                          Expanded(flex: 2, child: _PieChartCard()),
                          SizedBox(width: 20),
                          Expanded(flex: 3, child: _InsightsCard()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// STAT CARD
class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  const _StatCard(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: neonPink.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: neonPink.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 18),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: textGrey)),
        ],
      ),
    );
  }
}

/// PIE CHART
class _PieChartCard extends StatelessWidget {
  const _PieChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Booking Distribution",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 60,
                sectionsSpace: 4,
                sections: [
                  _section(55, Colors.greenAccent),
                  _section(25, Colors.orangeAccent),
                  _section(12, neonPink),
                  _section(8, purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static PieChartSectionData _section(double v, Color c) =>
      PieChartSectionData(
          value: v,
          color: c,
          radius: 70,
          title: "$v%",
          titleStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold));
}

/// 🔹 INSIGHTS — FIXED (NO OVERFLOW)
class _InsightsCard extends StatelessWidget {
  const _InsightsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Key Insights",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          /// ✅ SCROLL FIX
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  _Insight("📈 Revenue up 18% this month"),
                  _Insight("🔥 Premium service most booked"),
                  _Insight("⏳ Avg approval time: 2.3 hrs"),
                  _Insight("💳 Payment success: 98.6%"),
                  _Insight("⭐ User rating: 4.9/5"),
                  _Insight("🛡️ Zero security incidents"),
                  _Insight("⚡ System uptime: 99.98%"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Insight extends StatelessWidget {
  final String text;
  const _Insight(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child:
      Text(text, style: const TextStyle(color: textGrey, fontSize: 15)),
    );
  }
}
