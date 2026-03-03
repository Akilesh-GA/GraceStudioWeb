import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photofilters/photofilters.dart' as filters;
import 'package:image/image.dart' as img;

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

  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _showMessage(String message) {
    _scaffoldKey.currentState?.clearSnackBars();
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: const Color(0xFF6D28D9), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = bytes;
        _originalData = bytes;
      });
    }
  }

  Future<void> _applyFilters(BuildContext context) async {
    if (_imageData == null) {
      _showMessage("Upload an image first!");
      return;
    }

    setState(() => _isProcessing = true);

    try {
      img.Image? decodedImage = img.decodeImage(_imageData!);
      if (decodedImage == null) {
        _showMessage("Invalid image format");
        setState(() => _isProcessing = false);
        return;
      }

      if (decodedImage.width > 1500) {
        decodedImage = img.copyResize(decodedImage, width: 1500);
      }

      final Map? filteredResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => filters.PhotoFilterSelector(
            title: Text("Grace Studio Filters", style: GoogleFonts.poppins()),
            image: decodedImage!,
            filters: filters.presetFiltersList,
            filename: "edit_${DateTime.now().millisecondsSinceEpoch}.jpg",
            loader: const Center(child: CircularProgressIndicator(color: Color(0xFFEC4899))),
            fit: BoxFit.contain,
          ),
        ),
      );

      if (filteredResult != null && filteredResult.containsKey('image_filtered')) {
        final img.Image resultImg = filteredResult['image_filtered'];
        setState(() {
          _imageData = Uint8List.fromList(img.encodeJpg(resultImg));
          _isProcessing = false;
        });
        _showMessage("Filter Applied!");
      } else {
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showMessage("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Grace Studio", style: GoogleFonts.greatVibes(fontSize: 30, color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView( // Fixes Bottom Overflow
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // Preview Area with dynamic sizing
                    SizedBox(
                      height: constraints.maxHeight * 0.7,
                      child: Center(
                        child: _imageData == null
                            ? _buildEmptyState()
                            : _buildPreviewArea(),
                      ),
                    ),
                    // Control Panel at the bottom
                    _buildControlPanel(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPreviewArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _showOriginal ? "ORIGINAL VIEW" : "EDITED VIEW",
          style: TextStyle(
              color: _showOriginal ? Colors.yellow : Colors.pinkAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 20)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GestureDetector(
                onLongPressStart: (_) => setState(() => _showOriginal = true),
                onLongPressEnd: (_) => setState(() => _showOriginal = false),
                child: Image.memory(_showOriginal ? _originalData! : _imageData!, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text("Hold image to compare", style: TextStyle(color: Colors.white24, fontSize: 10)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.blur_on_rounded, size: 80, color: Colors.white.withOpacity(0.1)),
        const SizedBox(height: 20),
        const Text("Upload a photo to start editing", style: TextStyle(color: Colors.white24)),
      ],
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F13),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _toolButton(Icons.add_photo_alternate_outlined, "Import", _pickImage),
          _toolButton(
              _isProcessing ? Icons.sync : Icons.color_lens_outlined,
              "Filters",
              _isProcessing ? () {} : () => _applyFilters(context)
          ),
          _toolButton(Icons.history_rounded, "Reset", () {
            if (_originalData != null) {
              setState(() => _imageData = _originalData);
              _showMessage("Reverted to original");
            }
          }),
          _toolButton(Icons.ios_share_rounded, "Export", () => _showMessage("Exporting... (Web: Right click to save)")),
        ],
      ),
    );
  }

  Widget _toolButton(IconData icon, String label, VoidCallback action) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFEC4899), size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}