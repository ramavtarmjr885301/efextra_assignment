import 'package:exefextra_assignment/Screens/LoginScreen.dart';
import 'package:exefextra_assignment/Screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        Get.offAll(() => const Wrapper());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred';

        switch (e.code) {
          case 'email-already-in-use':
            message = 'This email is already in use.';
            break;
          case 'invalid-email':
            message = 'Invalid email address.';
            break;
          case 'weak-password':
            message = 'Password should be at least 6 characters.';
            break;
          default:
            message = e.message ?? message;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.06;
    final fontSize = size.width * 0.04;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(right: 30, left: 0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: size.width * 0.07,
                            ),
                          ),
                        ),
                        title: Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: size.width * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 56, 178, 235),
                          ),
                        ),

                        subtitle: Text(
                          'Create your account!',
                          style: TextStyle(fontSize: size.width * 0.05),
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),

                      /// Email Field
                      Text('E-mail', style: TextStyle(fontSize: fontSize)),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        controller: email,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            size: fontSize + 4,
                          ),
                          hintText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(fontSize: fontSize),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.025),

                      /// Password Field
                      Text('Password', style: TextStyle(fontSize: fontSize)),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        controller: password,
                        obscureText: _obscureText,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: fontSize + 4,
                          ),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: fontSize + 2,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        style: TextStyle(fontSize: fontSize),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.025),

                      /// Confirm Password Field
                      Text(
                        'Confirm Password',
                        style: TextStyle(fontSize: fontSize),
                      ),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureText,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: fontSize + 4,
                          ),
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(fontSize: fontSize),
                        validator: (value) {
                          if (value != password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.04),

                      /// Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 56, 178, 235),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _signup,
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),

                      /// Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: fontSize * 0.95),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromARGB(255, 56, 178, 235),
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
