import 'package:flutter/material.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';

class DrawerScreen extends StatefulWidget {
  final int selectedIndex;

  const DrawerScreen({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String userName = "Caricamento...";

  @override
  void initState() {
    super.initState();
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
                    const Text(
                      "Ciao, Hamouda!",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: 0.5,
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
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
              ),

              _drawerItem(
                icon: Icons.calendar_month_outlined,
                title: "Prenotazioni",
                onTap: () {},
              ),

              _drawerItem(
                icon: Icons.sports_soccer,
                title: "Campi",
                onTap: () {},
              ),

              _drawerItem(
                icon: Icons.person_outline,
                title: "Profilo",
                onTap: () {},
              ),

              _drawerItem(
                icon: Icons.settings_outlined,
                title: "Impostazioni",
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // ---- LOGOUT ----
              _drawerItem(
                icon: Icons.logout,
                title: "Disconnetti",
                color: Colors.red,
                onTap: () {},
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
