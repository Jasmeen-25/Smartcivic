
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'signup_screen.dart';

const Color loginNavy = Color(0xFF10243A);
const Color loginTeal = Color(0xFF16B8A6);
const Color loginBackground = Color(0xFFF3F7FB);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  Future<void> login() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your email and password.'),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await AuthService().login(
        email: email.text,
        password: password.text,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: loginTeal),
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
        borderSide: const BorderSide(color: Color(0xFFE5EBF1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: loginTeal,
          width: 1.7,
        ),
      ),
      labelStyle: const TextStyle(color: Colors.black54),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loginBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 25,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                children: [
                  // Logo and heading
                  Container(
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          loginNavy,
                          Color(0xFF176477),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: loginNavy.withOpacity(0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_city_rounded,
                      size: 47,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'SmartCivic',
                    style: TextStyle(
                      color: loginNavy,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Building better communities together',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: loginNavy.withOpacity(0.06),
                          blurRadius: 25,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: loginNavy,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Login to continue making a difference.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          'Email Address',
                          style: TextStyle(
                            color: loginNavy,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                            label: 'Enter your email',
                            icon: Icons.email_outlined,
                          ),
                        ),

                        const SizedBox(height: 21),

                        const Text(
                          'Password',
                          style: TextStyle(
                            color: loginNavy,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextField(
                          controller: password,
                          obscureText: obscurePassword,
                          onSubmitted: (_) {
                            if (!loading) login();
                          },
                          decoration: inputDecoration(
                            label: 'Enter your password',
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

                        const SizedBox(height: 28),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: loading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: loginNavy,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  loginNavy.withOpacity(0.5),
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
                                        'Login to Account',
                                        style: TextStyle(
                                          fontSize: 16,
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
                          children: [
                            const Expanded(
                              child: Divider(color: Color(0xFFE5EBF1)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Color(0xFFE5EBF1)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 19),

                        // Signup navigation
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: loginTeal,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: loginTeal,
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
