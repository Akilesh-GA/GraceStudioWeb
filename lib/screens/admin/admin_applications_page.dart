import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF9D4EDD);
const Color neonPink = Color(0xFFFF2FB3);
const Color textGrey = Color(0xFFB0B0C3);

class AdminApplicationsScreen extends StatefulWidget {
  const AdminApplicationsScreen({super.key});

  @override
  State<AdminApplicationsScreen> createState() =>
      _AdminApplicationsScreenState();
}

class _AdminApplicationsScreenState extends State<AdminApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatTimestamp(Timestamp ts) {
    return DateFormat('dd MMM yyyy • hh:mm a').format(ts.toDate());
  }

  Future<void> updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('join_requests')
        .doc(docId)
        .update({'status': status});
  }

  Color statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.greenAccent;
      case 'rejected':
        return neonPink;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [purple, neonPink],
                          ).createShader(bounds),
                          child: const Text(
                            "Applications Review",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Approve or reject photographer & staff applications",
                          style: TextStyle(color: textGrey),
                        ),
                        const SizedBox(height: 30),

                        /// APPLICATION LIST
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('join_requests')
                                .orderBy('createdAt', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: neonPink),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "No applications found",
                                    style: TextStyle(color: textGrey),
                                  ),
                                );
                              }

                              final docs = snapshot.data!.docs;

                              return ListView.separated(
                                itemCount: docs.length,
                                separatorBuilder: (_, __) =>
                                const SizedBox(height: 22),
                                itemBuilder: (context, index) {
                                  final doc = docs[index];
                                  final data =
                                  doc.data() as Map<String, dynamic>;

                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: 1),
                                    duration: Duration(
                                        milliseconds: 500 + index * 80),
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset:
                                        Offset(0, 20 * (1 - value)),
                                        child: Opacity(
                                            opacity: value, child: child),
                                      );
                                    },
                                    child: _ApplicationCard(
                                      data: data,
                                      docId: doc.id,
                                      formatTime: formatTimestamp,
                                      updateStatus: updateStatus,
                                      statusColor: statusColor,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 APPLICATION CARD (SAME STYLE AS BOOKING CARD)
class _ApplicationCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  final String Function(Timestamp) formatTime;
  final Function(String, String) updateStatus;
  final Color Function(String) statusColor;

  const _ApplicationCard({
    required this.data,
    required this.docId,
    required this.formatTime,
    required this.updateStatus,
    required this.statusColor,
  });

  @override
  State<_ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<_ApplicationCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.data['status'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.45),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: hover
                ? neonPink.withOpacity(0.25)
                : purple.withOpacity(0.15),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() => hover = false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.data['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.statusColor(status).withOpacity(0.3),
                        widget.statusColor(status).withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: widget.statusColor(status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(color: Colors.white12),

            Wrap(
              spacing: 40,
              runSpacing: 12,
              children: [
                _info("Email", widget.data['email']),
                _info("Role", widget.data['role']),
                _info("Resume", widget.data['resumeFileName']),
              ],
            ),

            const SizedBox(height: 14),
            Text(widget.data['message'],
                style: const TextStyle(color: textGrey)),

            const SizedBox(height: 16),
            Text(
              "Created • ${widget.formatTime(widget.data['createdAt'])}",
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),

            if (status == 'pending') ...[
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        widget.updateStatus(widget.docId, 'rejected'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: neonPink,
                      side: const BorderSide(color: neonPink),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Reject"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () =>
                        widget.updateStatus(widget.docId, 'approved'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [purple, neonPink],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 26, vertical: 14),
                        child: Text(
                          "Approve",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// INFO TILE
Widget _info(String label, String value) {
  return SizedBox(
    width: 260,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(color: textGrey, fontSize: 14)),
      ],
    ),
  );
}
