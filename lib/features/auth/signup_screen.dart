
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

const Color signupNavy = Color(0xFF10243A);
const Color signupTeal = Color(0xFF16B8A6);
const Color signupBackground = Color(0xFFF3F7FB);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  Future<void> signup() async {
    if (name.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter valid details. Password must be at least 6 characters.',
          ),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await AuthService().signup(
        name: name.text,
        email: email.text,
        password: password.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: signupTeal,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  InputDecoration fieldDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: signupTeal),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF6F9FC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 19,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE5EBF1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: signupTeal,
          width: 1.7,
        ),
      ),
      labelStyle: const TextStyle(color: Colors.black54),
    );
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: signupBackground,
      appBar: AppBar(
        backgroundColor: signupBackground,
        foregroundColor: signupNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                children: [
                  // Logo
                  Container(
                    height: 76,
                    width: 76,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          signupNavy,
                          Color(0xFF176477),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(23),
                      boxShadow: [
                        BoxShadow(
                          color: signupNavy.withOpacity(0.17),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_city_rounded,
                      size: 42,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Join SmartCivic',
                    style: TextStyle(
                      color: signupNavy,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Be a part of a smarter community.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 27),

                  // Signup form card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: signupNavy.withOpacity(0.06),
                          blurRadius: 25,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            color: signupNavy,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Enter your details to get started.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          'Full Name',
                          style: TextStyle(
                            color: signupNavy,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 9),

                        TextField(
                          controller: name,
                          textCapitalization: TextCapitalization.words,
                          decoration: fieldDecoration(
                            label: 'Enter your full name',
                            icon: Icons.person_outline_rounded,
                          ),
                        ),

                        const SizedBox(height: 19),

                        const Text(
                          'Email Address',
                          style: TextStyle(
                            color: signupNavy,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 9),

                        TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: fieldDecoration(
                            label: 'Enter your email',
                            icon: Icons.email_outlined,
                          ),
                        ),

                        const SizedBox(height: 19),

                        const Text(
                          'Password',
                          style: TextStyle(
                            color: signupNavy,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 9),

                        TextField(
                          controller: password,
                          obscureText: obscurePassword,
                          decoration: fieldDecoration(
                            label: 'Create a password',
                            icon: Icons.lock_outline_rounded,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: signupTeal,
                              size: 15,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Password must contain at least 6 characters.',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 27),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: loading ? null : signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: signupNavy,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  signupNavy.withOpacity(0.5),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: loading
                                ? const SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create My Account',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_forward_rounded),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 23),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: signupTeal,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 23),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: signupTeal,
                        size: 17,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Your community. Your voice. Your city.',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
