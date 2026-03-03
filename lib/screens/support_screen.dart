import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF7B2EFF);
const Color neonPink = Color(0xFFFF2FB3);
const Color cardBlack = Color(0xFF14141C);
const Color textGrey = Color(0xFFB0B0C3);

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();

  // State variables
  String _selectedCategory = "General Feedback";
  int _currentRating = 5;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? "";
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    if (_msgController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection("feedbacks").add({
        "userId": user.uid,
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "category": _selectedCategory,
        "rating": _currentRating,
        "message": _msgController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Logic for resetting the page for acknowledgement (Resetting fields)
      _nameController.clear();
      _msgController.clear();
      setState(() {
        _currentRating = 5;
        _isLoading = false;
        _selectedCategory = "General Feedback";
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        backgroundColor: bgBlack,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Grace Studio",
          style: GoogleFonts.greatVibes(fontSize: 28, color: Colors.white70),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Support & Feedback",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "We'd love to hear from you",
                      style: TextStyle(
                        fontSize: 16,
                        color: textGrey,
                      ),
                    ),
                    const SizedBox(height: 40),

                    Container(
                      width: 340,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: cardBlack,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                            color: neonPink.withOpacity(0.2),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInputField(
                            controller: _nameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 18),
                          _buildInputField(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 18),

                          _buildCategoryField(),

                          const SizedBox(height: 20),
                          const Text(
                            "Overall Rating",
                            style: TextStyle(color: textGrey, fontSize: 14),
                          ),
                          _buildStars(),
                          const SizedBox(height: 20),

                          _buildInputField(
                            controller: _msgController,
                            label: "Your Message",
                            icon: Icons.chat_bubble_outline,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 30),

                          GestureDetector(
                            onTap: _isLoading ? null : _submitFeedback,
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [purple, neonPink],
                                ),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                    : const Text(
                                  "Submit Feedback",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField() {
    final List<String> categories = [
      "General Feedback",
      "App Experience",
      "Service Quality",
      "Feature Suggestion",
      "Other"
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        dropdownColor: cardBlack,
        icon: const Icon(Icons.arrow_drop_down, color: neonPink),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: const InputDecoration(
          labelText: "Category",
          labelStyle: TextStyle(color: textGrey),
          prefixIcon: Icon(Icons.category_outlined, color: neonPink),
          border: InputBorder.none,
        ),
        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedCategory = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        cursorColor: neonPink,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: textGrey),
          prefixIcon: Icon(icon, color: neonPink),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) => IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
            index < _currentRating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: neonPink,
            size: 32
        ),
        onPressed: () => setState(() => _currentRating = index + 1),
      )),
    );
  }
}