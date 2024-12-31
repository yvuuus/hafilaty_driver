import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafilaty_driver/View/Components/all_components.dart';
import 'package:hafilaty_driver/View/Routes/routes.dart';
import 'package:hafilaty_driver/View/Screens/Auth_Screens/Login_Screen/login_logics.dart';
import 'package:hafilaty_driver/View/Screens/Auth_Screens/Login_Screen/login_providers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE1BEE7),
                  Color(0xFF9575CD),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: _buildIconCircle(Icons.person, "Driver"),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 20,
                    right: 20,
                  ),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTextFieldWithLabel(
                          controller: emailController,
                          label: "Email",
                          hintText: "Enter Email",
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        _buildTextFieldWithLabel(
                          controller: passwordController,
                          label: "Password",
                          hintText: "Enter Password",
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        Consumer(
                          builder: (context, ref, child) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: ref.watch(loginIsLoadingProvider)
                                  ? null
                                  : () => LoginLogics().loginUser(
                                        context,
                                        ref,
                                        emailController,
                                        passwordController,
                                      ),
                              child: Text(
                                ref.watch(loginIsLoadingProvider)
                                    ? "Loading..."
                                    : "Login",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height * 0.5,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/imgs/Bus-driver-amico.png"),
                          fit: BoxFit.contain,
                        ),
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
  }

  Widget _buildIconCircle(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 80,
            color: Colors.purple.shade700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithLabel({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF3E5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF6A1B9A)),
          ),
        ),
      ],
    );
  }
}
