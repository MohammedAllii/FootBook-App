import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/auth/welcome_screen.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: "Inizia ora",
      onFinish: () {
        Get.offAll(() =>  WelcomeScreen());
      },
      finishButtonStyle: const FinishButtonStyle(
        backgroundColor: Color.fromARGB(255, 51, 140, 85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(70)),
        ),
      ),
      skipTextButton: const Text(
        "Salta",
        style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 43, 99, 64),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Text(
        "Avanti",
        style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 43, 99, 64),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: null,
      controllerColor: const Color.fromARGB(255, 43, 99, 64),
      totalPage: 4,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,

      background: [
        Container(),
        Container(),
        Container(),
        Container(),
      ],
      speed: 10.8,

      pageBodies: [
        _buildPageBody(
          title: "Benvenuto su FootBook",
          description:
              "L’app più semplice ed efficiente per prenotare campi da calcio. Prenota il tuo campo in pochi secondi!",
          imagePath: 'assets/onboarding.png',
        ),
        _buildPageBody(
          title: "Prenotazione in Tempo Reale",
          description:
              "Controlla la disponibilità, scegli l’orario e prenota subito. Niente più telefonate!",
          imagePath: 'assets/onboarding1.png',
        ),
        _buildPageBody(
          title: "Per Tutti, Anche per le Donne",
          description:
              "FootBook è pensato anche per ragazze e donne che vogliono giocare, prenotare e divertirsi!",
          imagePath: 'assets/onboarding3.png',
        ),
        _buildPageBody(
          title: "Pagamenti Sicuri",
          description:
              "Paga in modo sicuro tramite il nostro sistema integrato. Ricevi la conferma immediatamente!",
          imagePath: 'assets/onboarding2.png',
        ),
      ],
    );
  }

  Widget _buildPageBody({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        final isLandscape = screenWidth > screenHeight;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
          ),
          child: isLandscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        imagePath,
                        height: screenHeight * 0.4,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _textSection(title, description),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePath,
                      height: screenHeight * 0.3,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    _textSection(title, description),
                  ],
                ),
        );
      },
    );
  }

  Widget _textSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(255, 43, 99, 64),
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
