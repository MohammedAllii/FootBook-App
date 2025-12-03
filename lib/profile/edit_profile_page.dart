import 'package:flutter/material.dart';
import 'package:footbookcamp/Help/help_center.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/calendar/calendar_page.dart';
import 'package:footbookcamp/campo/campi_list.dart';
import 'package:footbookcamp/profile/edit_info.dart';
import 'package:get/get.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  int selectedIndex = 3;
    final PageController controller = PageController();


  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profilo",style: TextStyle(fontWeight: FontWeight.bold),),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePicStatic(),
            const SizedBox(height: 40),
            ProfileMenu(
              text: "Il mio account",              
              icon: Icons.person,
              press: () => {
                 Get.to(() => EditInfo())
              },
            ),
            ProfileMenu(
              text: "Centro assistenza",
              icon: Icons.help_outline,
              press: () {
                Get.to(() => HelpCenter());

              },
            ),
            SizedBox(height: 40,),
            ProfileMenu(
              text: "Esci",
              icon: Icons.logout,
              press: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 20,
        offset: const Offset(0, -10),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
    child: SlidingClippedNavBar(
      backgroundColor: Colors.white,
            onButtonPressed: (index) {
        setState(() {
          selectedIndex = index;
        });

        // --- NAVIGATION ---
        switch (index) {
          case 0:
            Get.to(() => HomeScreen());

            break;

          case 1:
            Get.to(() => CalendarPage());

            break;

          case 2:
          Get.to(() => CampiList());
            break;

          case 3:
            Get.to(() => ProfileScreen());

            break;
        }
      },
      iconSize: 32,
      activeColor: Colors.black,
      inactiveColor: Colors.grey,
      selectedIndex: selectedIndex,
      barItems:  [
        BarItem(icon: Icons.home, title: 'Home'),
        BarItem(icon: Icons.calendar_month_outlined, title: 'Events'),
        BarItem(icon: Icons.search, title: 'Search'),
        BarItem(icon: Icons.account_circle, title: 'Profil'),
      ],
    ),
  ),
),
    );
  }
}

// ---------------- IMAGE STATIQUE ----------------
class ProfilePicStatic extends StatelessWidget {
  const ProfilePicStatic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black, // 🔥 Bordure noire
            width: 3,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(3), // espace entre bordure et image
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/profile.png"),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}


// ---------------- MENU PROFIL ----------------
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF44a4a4).withOpacity(0.35),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF44a4a4).withOpacity(0.9),
              size: 26,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color.fromARGB(255, 9, 9, 9),
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
