import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photofilters/photofilters.dart' as filters;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class EditingStudioScreen extends StatefulWidget {
  const EditingStudioScreen({super.key});

  @override
  State<EditingStudioScreen> createState() => _EditingStudioScreenState();
}

class _EditingStudioScreenState extends State<EditingStudioScreen> {
  Uint8List? _imageData;
  Uint8List? _originalData;
  bool _showOriginal = false;
  bool _isProcessing = false;

  // 1. STATED INITIALIZATION: Ensure this is never null or ambiguous
  String _statusMessage = "GRACE STUDIO READY";

  final picker = ImagePicker();

  void _updateStatus(String msg) {
    if (!mounted) return;
    setState(() => _statusMessage = msg);
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _statusMessage = _imageData == null ? "READY TO START" : "STUDIO ACTIVE";
        });
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageData = bytes;
          _originalData = bytes;
        });
        _updateStatus("IMAGE IMPORTED");
      }
    } catch (e) {
      _updateStatus("IMPORT FAILED");
    }
  }

  Future<void> _applyFilters(BuildContext context) async {
    if (_imageData == null) return;
    setState(() => _isProcessing = true);

    try {
      img.Image? decodedImage = img.decodeImage(_imageData!);
      if (decodedImage == null) {
        _updateStatus("UNSUPPORTED FORMAT");
        setState(() => _isProcessing = false);
        return;
      }

      if (decodedImage.width > 1200) {
        decodedImage = img.copyResize(decodedImage, width: 1200);
      }

      final Map? filteredResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => filters.PhotoFilterSelector(
            title: Text("STUDIO PRESETS",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            image: decodedImage!,
            filters: filters.presetFiltersList,
            filename: "studio_${DateTime.now().millisecondsSinceEpoch}.jpg",
            loader: const Center(child: CircularProgressIndicator(color: Color(0xFFEC4899))),
            fit: BoxFit.contain,
          ),
        ),
      );

      if (filteredResult != null && filteredResult.containsKey('image_filtered')) {
        setState(() {
          _imageData = Uint8List.fromList(img.encodeJpg(filteredResult['image_filtered']));
          _isProcessing = false;
        });
        _updateStatus("FILTER APPLIED");
      } else {
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _updateStatus("PROCESS ERROR");
    }
  }

  Future<void> _downloadImage() async {
    if (_imageData == null) return;
    setState(() => _isProcessing = true);
    _updateStatus("DOWNLOADING...");

    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await Permission.photos.request();
      }

      final result = await ImageGallerySaver.saveImage(
        _imageData!,
        quality: 95,
        name: "GraceStudio_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result != null && result['isSuccess'] == true) {
        _updateStatus("SAVED TO GALLERY ✨");
      } else {
        _updateStatus("DOWNLOAD FAILED");
      }
    } catch (e) {
      _updateStatus("DOWNLOAD ERROR");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. DEFENSIVE CODING: Extract logic to local variables with null checks
    // We use 'contains' only after ensuring the object isn't undefined in JS terms.
    final currentStatus = _statusMessage;
    final bool isSuccess = currentStatus.isNotEmpty && currentStatus.contains("✨");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Grace Studio",
            style: GoogleFonts.greatVibes(fontSize: 34, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  currentStatus,
                  style: GoogleFonts.poppins(
                      color: isSuccess ? Colors.greenAccent : Colors.white24,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _imageData == null
                      ? _buildEmptyState()
                      : _buildPreviewArea(),
                ),
              ),
              _buildControlPanel(context),
            ],
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFEC4899), strokeWidth: 3),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewArea() {
    // 3. SAFE LOCALS: Create local references to avoid racing conditions during rebuilds
    final Uint8List? data = _imageData;
    final Uint8List? original = _originalData;

    if (data == null || original == null) return _buildEmptyState();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onLongPressStart: (_) => setState(() => _showOriginal = true),
                onLongPressEnd: (_) => setState(() => _showOriginal = false),
                child: Image.memory(
                    _showOriginal ? original : data,
                    fit: BoxFit.contain
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
            _showOriginal ? "VIEWING ORIGINAL" : "LONG PRESS TO COMPARE",
            style: GoogleFonts.poppins(color: Colors.white10, fontSize: 9, fontWeight: FontWeight.bold)
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.photo_filter_rounded, size: 60, color: Colors.white.withOpacity(0.05)),
        const SizedBox(height: 20),
        Text("IMPORT IMAGE TO START",
            style: GoogleFonts.poppins(color: Colors.white12, fontSize: 11, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    final bool hasImage = _imageData != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 25, bottom: 45, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F13),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _studioButton(Icons.add_photo_alternate_rounded, "IMPORT", _pickImage),
          _studioButton(Icons.style_rounded, "PRESETS", hasImage ? () => _applyFilters(context) : null),
          _studioButton(Icons.refresh_rounded, "RESET", hasImage ? () {
            setState(() => _imageData = _originalData);
            _updateStatus("RESET COMPLETE");
          } : null),
          _studioButton(Icons.file_download_outlined, "DOWNLOAD", hasImage ? _downloadImage : null),
        ],
      ),
    );
  }

  Widget _studioButton(IconData icon, String label, VoidCallback? action) {
    return Opacity(
      opacity: action == null ? 0.2 : 1.0,
      child: InkWell(
        onTap: action,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFEC4899), size: 28),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}