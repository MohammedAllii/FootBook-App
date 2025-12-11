import 'package:flutter/material.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/Services/AuthService.dart';
import 'package:footbookcamp/auth/login_screen.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:footbookcamp/calendar/calendar_page.dart';
import 'package:footbookcamp/campo/campi_list.dart';
import 'package:footbookcamp/profile/edit_info.dart';
import 'package:footbookcamp/profile/edit_profile_page.dart';

class DrawerScreen extends StatefulWidget {
  final int selectedIndex;

  const DrawerScreen({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final AuthService _authService = AuthService();

  String userName = "Caricamento...";
  String userEmail = "";
  String userFullName = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Récupérer les infos utilisateur
  void _loadUserData() async {
    try {
      final userData = await _authService.getUser();
      setState(() {
        userFullName = "${userData['nome']} ${userData['cognome']}";
        userEmail = userData['email'] ?? "";
        userName = userData['nome'] ?? "Utente";
      });
    } catch (e) {
      setState(() {
        userName = "Utente";
        userEmail = "";
      });
      print("Errore nel caricamento utente: $e");
    }
  }

  void _logout() async {
    try {
      await _authService.logout();
      CherryToast.success(
        title: const Text("Logout avvenuto con successo"),
        displayIcon: true,
        animationType: AnimationType.fromLeft,
      ).show(context);

      // Redirection vers LoginScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      CherryToast.error(
        title: Text("Errore durante il logout: $e"),
        displayIcon: true,
        animationType: AnimationType.fromLeft,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---- HEADER ----
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.9),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/profile.png",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userFullName.isNotEmpty ? userFullName : "Utente",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail.isNotEmpty ? userEmail : "",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // ---- MENU ----
              _drawerItem(
                icon: Icons.home_outlined,
                title: "Home",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
              ),

              _drawerItem(
                icon: Icons.calendar_month_outlined,
                title: "Prenotazioni",
                onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CalendarPage()),
                  );
                },
              ),

              _drawerItem(
                icon: Icons.sports_soccer,
                title: "Campi",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  CampiList()),
                  );
                },
              ),

              _drawerItem(
                icon: Icons.person_outline,
                title: "Profilo",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),


              const SizedBox(height: 40),

              // ---- LOGOUT ----
              _drawerItem(
                icon: Icons.logout,
                title: "Disconnetti",
                color: Colors.red,
                onTap: _logout,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
