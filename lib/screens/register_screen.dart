import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = "";
  String selectedRole = "User";

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
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(
                position: slideAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Register to get started",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 30),

                    Container(
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

                          // 🔥 ADDED ROLE TOGGLE (NO BORDER)
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _roleButton("User", Icons.person),
                                _roleButton("Admin", Icons.admin_panel_settings),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          InputField(
                            controller: nameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                          ),
                          SizedBox(height: 18),

                          InputField(
                            controller: phoneController,
                            label: "Phone Number",
                            icon: Icons.phone_outlined,
                          ),
                          SizedBox(height: 18),

                          InputField(
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                          ),
                          SizedBox(height: 18),

                          InputField(
                            controller: passwordController,
                            label: "Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          SizedBox(height: 10),

                          if (errorMessage.isNotEmpty)
                            Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          SizedBox(height: 20),

                          GestureDetector(
                            onTap: _handleRegister,
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: tColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign Up",
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
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Already have an account? Login",
                              style: TextStyle(
                                color: tColor,
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
      ),
    );
  }

  // 🔥 ROLE BUTTON WIDGET
  Widget _roleButton(String role, IconData icon) {
    bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? tColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : tColor,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              role,
              style: TextStyle(
                color: isSelected ? Colors.white : tColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    setState(() => errorMessage = "");

    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Please fill all fields");
      return;
    }

    if (!email.contains("@")) {
      setState(() => errorMessage = "Invalid email format");
      return;
    }

    if (password.length < 6) {
      setState(() => errorMessage = "Password must be at least 6 characters");
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": name,
        "phone": phone,
        "email": email,
        "role": selectedRole,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Registration failed";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Something went wrong";
      });
    }
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;

  const InputField({
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
