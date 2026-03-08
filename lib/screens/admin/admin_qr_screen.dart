import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF7B2EFF);
const Color neonPink = Color(0xFFFF2FB3);
const Color cardBlack = Color(0xFF14141C);
const Color textGrey = Color(0xFFB0B0C3);

class AdminQRScreen extends StatefulWidget {
  const AdminQRScreen({super.key});

  @override
  State<AdminQRScreen> createState() => _AdminQRScreenState();
}

class _AdminQRScreenState extends State<AdminQRScreen> {
  final TextEditingController _linkController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  String _qrData = "";

  /// 📤 Share QR Functionality
  Future<void> _shareQr() async {
    if (_qrData.isEmpty) return;

    // Capture the widget as an image
    final Uint8List? image = await _screenshotController.capture(
      delay: const Duration(milliseconds: 10),
      pixelRatio: 3.0, // High res for printing
    );

    if (image != null) {
      final xFile = XFile.fromData(
        image,
        name: 'live_gallery_qr.png',
        mimeType: 'image/png',
      );
      await Share.shareXFiles([xFile], text: 'Scan to join the Live Gallery!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: cardBlack,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                  color: purple.withOpacity(0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 HEADER
                const Icon(Icons.cloud_sync_rounded, color: neonPink, size: 48),
                const SizedBox(height: 16),
                const Text(
                  "Live QR Generator",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Paste your Google Drive link. Users can scan this to see images live as you upload them.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textGrey),
                ),

                const SizedBox(height: 40),

                /// 🔹 LINK INPUT FIELD
                TextField(
                  controller: _linkController,
                  onChanged: (value) => setState(() => _qrData = value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "https://drive.google.com/...",
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.black,
                    prefixIcon: const Icon(Icons.link, color: purple),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: neonPink),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔹 QR CODE PREVIEW (Wrapped for Screenshot)
                Screenshot(
                  controller: _screenshotController,
                  child: _buildQRPreview(),
                ),

                const SizedBox(height: 30),

                /// 🔹 ACTION BUTTONS
                if (_qrData.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        label: "Share QR",
                        icon: Icons.share_rounded,
                        color: purple,
                        onTap: _shareQr,
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        label: "Export QR",
                        icon: Icons.file_download_outlined,
                        color: Colors.white10,
                        onTap: () {
                          // Note: On Web/Desktop, Share often acts as Download
                          _shareQr();
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 BOX STYLE QR DESIGN
  Widget _buildQRPreview() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _qrData.isEmpty ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: _qrData.isEmpty ? Colors.white12 : neonPink, width: 2),
      ),
      child: _qrData.isEmpty
          ? const SizedBox(
        height: 220,
        width: 220,
        child: Center(
          child: Text(
            "Awaiting Link...",
            style:
            TextStyle(color: textGrey, fontWeight: FontWeight.bold),
          ),
        ),
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: _qrData,
            size: 220,
            version: QrVersions.auto,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xFF0B0B0F),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Color(0xFF0B0B0F),
            ),
            gapless: true,
          ),
          const SizedBox(height: 12),
          const Text(
            "SCAN FOR LIVE GALLERY",
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 HELPER FOR BUTTONS
  Widget _buildActionButton(
      {required String label,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: color == purple ? color : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}