import 'package:exefextra_assignment/Screens/ForgotPassword.dart';
import 'package:exefextra_assignment/Screens/SignUpScreen.dart';
import 'package:exefextra_assignment/Screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      

      // 🛡️ prevents using unmounted context
      // 🛡️ prevents using unmounted context
 if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      // Navigate to another screen if needed here
      
      Get.offAll(() => const Wrapper());

      

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      } else {
        message = e.message ?? message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }
}


  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.06;
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
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(right: 60, left: 0),
                          child: Icon(Icons.arrow_back_ios,
                              size: size.width * 0.07,
                               color: Color(0xff312E49),) 
                        ),
                        title: Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: size.width * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0097B2),
                            // 0xff312E49 black 
                            //  0xff0097B2 blue
                            
                          ),
                        ),

                        subtitle: Text(
                          'Glad to see you!',
                          style: TextStyle(fontSize: size.width * 0.05, color: Color(0xff312E49), fontWeight: FontWeight.bold),
                        ),
                      ),

                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: size.width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0097B2),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'E-mail',
                        style: TextStyle(fontSize: size.width * 0.038, color: Color(0xff312E49)),
                      ),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        controller: email,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            size: size.width * 0.06,
                          ),
                          hintText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(fontSize: size.width * 0.04),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.025),
                      Text(
                        'Password',
                        style: TextStyle(fontSize: size.width * 0.038, color: Color(0xff312E49)),
                      ),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        controller: password,
                        enabled: !_isLoading,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: size.width * 0.06,
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
                              size: size.width * 0.05,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        style: TextStyle(fontSize: size.width * 0.04),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.01),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ⓘ Must be at least 6 characters.',
                            style: TextStyle(
                              fontSize: size.width * 0.032,
                              color: Colors.grey,
                            ),
                          ),
                          TextButton(
                            onPressed:
                                _isLoading
                                    ? null
                                    : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  ResetPasswordScreen(),
                                        ),
                                      );
                                    },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: size.width * 0.038,
                                color: Color(0xff0097B2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),

                      SizedBox(
                        width: double.infinity,
                        height: size.height * 0.07,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0097B2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: size.width * 0.065,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(fontSize: size.width * 0.038),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Color(0xff0097B2),
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.039,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xff0097B2),
                                
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.04),
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
