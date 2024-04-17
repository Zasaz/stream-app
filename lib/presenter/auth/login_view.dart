import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/remote/controllers/auth_controller.dart';
import '../home/package_view.dart';
import '../../utils/theme/app_colors.dart';
import '../../utils/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String firstName;
  final String lastName;
  const LoginScreen(
      {super.key, required this.firstName, required this.lastName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authControllerNotifier);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/image_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 22,
            left: 5,
            child: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Welcome ${widget.firstName}",
                    style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Login to your account",
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(35),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 12,
                    color: Colors.white.withOpacity(0.55), // Semi-transparent
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                labelText: "Username",
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                } else if (value.length < 3 ||
                                    value.length > 50) {
                                  return 'Username must be between 3 and 50 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => _toggle(),
                                  icon: const Icon(
                                    Icons.remove_red_eye,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              child: const Text("Login"),
                              onPressed: () async {
                                if (usernameController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  FocusScope.of(context)
                                      .unfocus(); // Hide keyboard when button is pressed
                                  await authProvider.login(
                                    usernameController.text.trim(),
                                    passwordController.text.trim(),
                                    widget.firstName.trim(),
                                    widget.lastName.trim(),
                                  );

                                  // After login attempt
                                  if (authProvider.statusCode == "200") {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PackageView()),
                                    );
                                    showToast(AppColors.blueShade50,
                                        authProvider.message);
                                  } else {
                                    showToast(
                                        AppColors.errorToastColor,
                                        authProvider.message.isNotEmpty
                                            ? authProvider.message
                                            : 'Please try again later.');
                                  }
                                } else {
                                  if (!mounted) return;
                                  showToast(
                                    AppColors.errorToastColor,
                                    'Username and password cannot be empty',
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
