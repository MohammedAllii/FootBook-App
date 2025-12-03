import 'dart:ui';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:get/get.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CherryToast.error(
        title: const Text("Per favore, compila tutti i campi"),
        displayIcon: true,
        animationType: AnimationType.fromLeft,
      ).show(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // logica login qui

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: 350,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 50,
                      width: 250,
                      height: 400,
                      child: FadeInUp(
                        duration: const Duration(seconds: 2),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/giocatore1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Accedi",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF44a4a4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF44a4a4)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF44a4a4),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFF44a4a4)),
                              ),
                            ),
                            child: TextField(
                              controller: _controllerEmail,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _controllerPassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                        // _login();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF44a4a4), Color(0xFF44a4a4)],
                          ),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Accedi",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      ),
    );
  }
}
