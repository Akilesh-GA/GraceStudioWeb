import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'admin/admin_home_screen.dart';

const Color bgBlack = Color(0xFF0B0B0F);
const Color purple = Color(0xFF7B2EFF);
const Color neonPink = Color(0xFFFF2FB3);
const Color cardBlack = Color(0xFF14141C);
const Color textGrey = Color(0xFFB0B0C3);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: FadeTransition(
                    opacity: fadeAnim,
                    child: SlideTransition(
                      position: slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Login to continue",
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
                                  color: neonPink.withOpacity(0.25),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                LoginInputField(
                                  controller: emailController,
                                  label: "Email",
                                  icon: Icons.email_outlined,
                                ),
                                const SizedBox(height: 18),

                                LoginInputField(
                                  controller: passwordController,
                                  label: "Password",
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                ),

                                const SizedBox(height: 12),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _forgotPassword,
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(color: neonPink),
                                    ),
                                  ),
                                ),

                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 25),

                                GestureDetector(
                                  onTap: _handleLogin,
                                  child: Container(
                                    height: 55,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                        colors: [purple, neonPink],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 25),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Don't have an account? Sign Up",
                                    style: TextStyle(
                                      color: neonPink,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 🔹 FETCH ROLE FROM FIRESTORE
  Future<String> _getUserRole(String email) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        final role = data['role']?.toString().trim();
        if (role != null && role.isNotEmpty) {
          return role;
        }
      } else {
        print("No user document found for email: $email");
      }
    } catch (e) {
      print("Firestore role fetch error: $e");
    }
    return "User"; // default role
  }

  /// 🔹 HANDLE LOGIN WITH ROLE-BASED NAVIGATION
  Future<void> _handleLogin() async {
    setState(() => errorMessage = "");
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Please enter email and password");
      return;
    }

    try {
      // 1️⃣ Sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2️⃣ Fetch role from Firestore
      final role = (await _getUserRole(email)).toLowerCase();
      print("Logged in as role: $role"); // Debug

      // 3️⃣ Role-based redirection
      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Login failed";
      });
    }
  }


  Future<void> _forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() => errorMessage = "Enter email to reset password");
      return;
    }

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    setState(() => errorMessage = "Password reset email sent");
  }
}

class LoginInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;

  const LoginInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
  });

  @override
  State<LoginInputField> createState() => _LoginInputFieldState();
}

class _LoginInputFieldState extends State<LoginInputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        cursorColor: neonPink,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: textGrey),
          prefixIcon: Icon(widget.icon, color: neonPink),
          border: InputBorder.none,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: neonPink,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
