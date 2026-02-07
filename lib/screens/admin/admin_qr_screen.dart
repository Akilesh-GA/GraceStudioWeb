import 'dart:typed_data';
import 'dart:convert';
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
  // DEVICE UPLOAD
  List<Uint8List> _deviceImages = [];
  // URL UPLOAD
  List<String> _urlImages = [];

  String? _qrData;
  bool _loading = false;
  final urlController = TextEditingController();

  /// 📸 Pick Multiple Images from Device
  Future<void> _pickDeviceImages() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images == null || images.isEmpty) return;

    setState(() => _loading = true);

    List<Uint8List> bytesList = [];
    List<String> urlList = [];

    for (var image in images) {
      final bytes = await image.readAsBytes();
      bytesList.add(bytes);
      // Simulate a local URL using base64 for QR
      urlList.add(base64Encode(bytes));
    }

    setState(() {
      _deviceImages = bytesList;
      _qrData = jsonEncode(urlList);
      _loading = false;
    });
  }

  /// 🔗 Add Image URL
  void _addImageUrl() {
    final url = urlController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _urlImages.add(url);
      _qrData = jsonEncode(_urlImages);
      urlController.clear();
    });
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
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
                  "Generate QR codes for albums and photos",
                  style: TextStyle(color: textGrey),
                ),

                const SizedBox(height: 30),

                /// ----------------- DEVICE UPLOAD MODULE -----------------
                const Text(
                  "Device Upload",
                  style: TextStyle(
                      color: neonPink,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                      padding: const EdgeInsets.all(8.0),
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
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _loading ? null : _pickDeviceImages,
                  child: Container(
                    height: 50,
                    width: 200,
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
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// ----------------- URL UPLOAD MODULE -----------------
                const Text(
                  "URL Upload",
                  style: TextStyle(
                      color: neonPink,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: urlController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter image URL",
                          hintStyle: const TextStyle(color: textGrey),
                          filled: true,
                          fillColor: cardBlack,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _addImageUrl,
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [purple, neonPink],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Add URL",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                if (_urlImages.isNotEmpty)
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _urlImages.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Center(
                            child: Text(
                              _urlImages[index],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                /// ----------------- QR CODE -----------------
                if (_qrData != null)
                  Column(
                    children: [
                      const Text(
                        "Generated QR Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: QrImageView(
                          data: _qrData!,
                          size: 200,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Scan to view images",
                        style: TextStyle(color: textGrey),
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
