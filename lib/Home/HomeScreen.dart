// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:footbookcamp/calendar/calendar_page.dart';
import 'package:footbookcamp/campo/campi_list.dart';
import 'package:footbookcamp/campo/details_campo.dart';
import 'package:footbookcamp/profile/edit_profile_page.dart';
import 'package:footbookcamp/utils/drawer_screen.dart';
import 'package:get/get.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int selectedIndex = 0;
    final PageController controller = PageController();


  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

final List<Widget> pages = [
  CalendarPage(),
];

  // Liste des stades
  final List<Map<String, dynamic>> fields = [
    {
      "name": "Stadio Verde Arena",
      "type": "Calcetto 5v5",
      "image": "assets/stadium1.jpg",
      "rating": 4.7,
      "isAvailable": true,
    },
    {
      "name": "Campo Sportivo Centrale",
      "type": "Calcio a 7",
      "image": "assets/stadium2.jpg",
      "rating": 4.5,
      "isAvailable": false,
    },
    {
      "name": "Stadio Verde Arena",
      "type": "Calcetto 5v5",
      "image": "assets/stadium1.jpg",
      "rating": 4.7,
      "isAvailable": true,
    },
    {
      "name": "Campo Sportivo Centrale",
      "type": "Calcio a 7",
      "image": "assets/stadium2.jpg",
      "rating": 4.5,
      "isAvailable": false,
    },
    {
      "name": "Stadio Verde Arena",
      "type": "Calcetto 5v5",
      "image": "assets/stadium1.jpg",
      "rating": 4.7,
      "isAvailable": true,
    },
    {
      "name": "Campo Sportivo Centrale",
      "type": "Calcio a 7",
      "image": "assets/stadium2.jpg",
      "rating": 4.5,
      "isAvailable": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: DrawerScreen(selectedIndex: 1,), 

appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  leading: Builder(
    builder: (context) {
      return IconButton(
        icon: const Icon(Icons.menu, color: Colors.black, size: 28),
        onPressed: () {
          Scaffold.of(context).openDrawer(); // 👈 fonctionne 100%
        },
      );
    },
  ),

  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        padding: const EdgeInsets.all(2), // espace pour la bordure
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2), // 🔥 border noire
        ),
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/profile.png"),
          radius: 20,
          backgroundColor: Colors.white,
        ),
      ),
    ),
  ],
),


      body: PageView(
      physics: NeverScrollableScrollPhysics(),       
      controller: controller,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [                      

                      SizedBox(height: 5.h),
                      // --- CARD TOP LE MIE PRENOTAZIONI ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 235, 247, 240),
                                Colors.white,
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                            },
                            child: Row(
                              children: [
                                // Image à gauche
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  child: Image.asset(
                                    "assets/bienvenu.png",
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // Description à droite pour la page Home
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Benvenuto su FootBook",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Scopri e prenota facilmente i migliori campi da calcio vicino a te.",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // --- LE MIE PRENOTAZIONI ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Le mie prenotazioni",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {                                  Get.to(() => CalendarPage());
},
                              child: const Text(
                                "Vedi tutte",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15.h),

                      // --- CARD PROCHAINE PRENOTAZIONE ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 232, 248, 239),
                                    Colors.white,
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  // Image à gauche
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/stadium.jpg",
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Description à droite
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 255, 255, 255), // fond du badge
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                            0.15,
                                                          ), // ombre externe
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "Stadio Verde Arena",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                        const SizedBox(height: 5),
                                        // Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 98, 161, 129),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Text(
                                            "Oggi • 20:30",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(255, 255, 255, 255), // fond du badge
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.15,
                                                ), // ombre externe
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            "Non dimenticare di portare con te l'attrezzatura necessaria e arrivare qualche minuto prima.",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // --- TROVA UN CAMPO ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Trova un campo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.filter_list,
                              color: Colors.green,
                              size: 28,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // --- LISTE DES STADES AVEC GRADIENT AUTOUR ---
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: fields.length,
                          itemBuilder: (context, index) {
                            final field = fields[index];
                            return Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.white, Color(0xFF2ECC71)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomLeft,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.only(left: 12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Get.to(() => DetailsCampo());
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 4,
                                  child: Container(
                                    width: 300,
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.asset(
                                                field["image"],
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 255, 255, 255), // fond du badge
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                            0.15,
                                                          ), // ombre externe
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  field["name"],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                field["type"],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${field["rating"]}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
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


        ),
      ],
    );
  }
}
