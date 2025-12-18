import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";

  final Color tColor = Color(0xFF1ABC9C);

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    slideAnim = Tween<Offset>(
      begin: Offset(0, 0.2),
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: fadeAnim,
                          child: Column(
                            children: [
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Login to continue",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),

                        FadeTransition(
                          opacity: fadeAnim,
                          child: SlideTransition(
                            position: slideAnim,
                            child: Container(
                              width: 340,
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                    color: Colors.black.withOpacity(0.07),
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
                                  SizedBox(height: 18),

                                  LoginInputField(
                                    controller: passwordController,
                                    label: "Password",
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                  ),

                                  SizedBox(height: 10),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: _forgotPassword,
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(color: tColor),
                                      ),
                                    ),
                                  ),

                                  if (errorMessage.isNotEmpty)
                                    Text(
                                      errorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  SizedBox(height: 20),

                                  /// 🔐 LOGIN BUTTON (LOGIC UPDATED ONLY)
                                  GestureDetector(
                                    onTap: _handleLogin,
                                    child: Container(
                                      height: 55,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: tColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
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

                                  SizedBox(height: 25),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => RegisterScreen()),
                                      );
                                    },
                                    child: Text(
                                      "Don't have an account? Sign Up",
                                      style: TextStyle(
                                        color: tColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Future<void> _handleLogin() async {
    setState(() => errorMessage = "");

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Please enter email and password");
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Login failed";
      });
    }
  }

  Future<void> _forgotPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() => errorMessage = "Enter email to reset password");
      return;
    }

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    setState(() => errorMessage = "Password reset email sent");
  }
}

class LoginInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;

  const LoginInputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color tColor = Color(0xFF1ABC9C);

    return TextField(
      controller: controller,
      obscureText: isPassword,
      cursorColor: tColor,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: tColor),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tColor, width: 2),
        ),
        contentPadding: EdgeInsets.only(bottom: 5),
      ),
      style: TextStyle(fontSize: 16),
    );
  }
}
