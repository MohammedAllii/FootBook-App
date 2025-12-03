import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/auth/login_screen.dart';
import 'package:get/get.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerCognome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerEta = TextEditingController();

  bool _isLoading = false;

  void _signup() {
    final nome = _controllerNome.text.trim();
    final cognome = _controllerCognome.text.trim();
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();
    final eta = _controllerEta.text.trim();

    if (nome.isEmpty || cognome.isEmpty || email.isEmpty || password.isEmpty || eta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Per favore, compila tutti i campi')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Logica registrazione

    setState(() {
      _isLoading = false;
    });
  }

  Widget buildInputField(TextEditingController controller, String hint,
      {bool obscure = false, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF44a4a4)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF44a4a4).withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                              image: AssetImage('assets/giocatore.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              "Registrati",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF44a4a4)),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  // Nome e Cognome su stessa linea
                  Row(
                    children: [
                      Expanded(child: buildInputField(_controllerNome, "Nome")),
                      const SizedBox(width: 10),
                      Expanded(child: buildInputField(_controllerCognome, "Cognome")),
                    ],
                  ),
                  buildInputField(_controllerEmail, "Email", keyboardType: TextInputType.emailAddress),
                  buildInputField(_controllerPassword, "Password", obscure: true),
                  buildInputField(
                    _controllerEta,
                    "Età",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _signup,
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
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Registrati",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () =>  Get.to(LoginScreen()),
                    child: const Text(
                      "Hai già un account? Accedi",
                      style: TextStyle(color: Color(0xFF44a4a4), fontWeight: FontWeight.bold),
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
