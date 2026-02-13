import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  final List<Uint8List> _deviceImages = [];
  String? _qrData;
  bool _loading = false;

  /// 📸 Pick Images from Laptop / PC
  Future<void> _pickDeviceImages() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images == null || images.isEmpty) return;

    setState(() => _loading = true);

    _deviceImages.clear();

    for (var image in images) {
      final bytes = await image.readAsBytes();
      _deviceImages.add(bytes);
    }

    /// ✅ SAFE QR INPUT (SHORT STRING)
    final String imageId =
        "IMG_${DateTime.now().millisecondsSinceEpoch}";

    setState(() {
      _qrData = imageId; // 👈 QR contains ONLY ID
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: 900,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: cardBlack,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: neonPink.withOpacity(0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 TITLE
                const Text(
                  "QR Image Generator",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Upload images and generate QR for users to scan",
                  style: TextStyle(color: textGrey),
                ),

                const SizedBox(height: 30),

                /// 🔹 DEVICE UPLOAD
                const Text(
                  "Device Upload",
                  style: TextStyle(
                    color: neonPink,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: _deviceImages.isEmpty
                      ? const Center(
                    child: Text(
                      "No images selected",
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _deviceImages.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.memory(
                          _deviceImages[index],
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: _loading ? null : _pickDeviceImages,
                  child: Container(
                    height: 50,
                    width: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [purple, neonPink],
                      ),
                    ),
                    child: Center(
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Select Images",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔹 QR CODE SECTION
                if (_qrData != null)
                  Column(
                    children: [
                      const Text(
                        "Generated QR Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: QrImageView(
                          data: _qrData!,
                          size: 220,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "QR ID: $_qrData",
                        style: const TextStyle(color: textGrey),
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
}
