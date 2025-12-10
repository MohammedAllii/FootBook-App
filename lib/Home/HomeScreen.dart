
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:footbookcamp/Model/campi_model.dart';
import 'package:footbookcamp/Model/prenotazione_model.dart';
import 'package:footbookcamp/Services/campi_service.dart';
import 'package:footbookcamp/Services/reservation_service.dart';
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
  final CampiService _campiService = CampiService();
  final ReservationService _reservationService = ReservationService();
  late Future<List<Campo>> futureCampi;
  Prenotazione? _todayReservation;

  @override
  void initState() {
    super.initState();
    futureCampi = _campiService.getAllCampi();
    _loadTodayReservation();
  }

  void _loadTodayReservation() async {
    final reservation = await _reservationService.getTodayNextReservation(1); 
    setState(() {
      _todayReservation = reservation;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // CARD quand il y a une réservation
  Widget _buildNextAppointmentCardWithData(Prenotazione reservation) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 30,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 232, 248, 239), Colors.white],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Campo ID: ${reservation.campiId}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 98, 161, 129),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Oggi • ${reservation.ora}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Non dimenticare di portare con te l'attrezzatura necessaria e arrivare qualche minuto prima.",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 8,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CARD quand il n'y a pas de réservation
  Widget _buildNoAppointmentCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 240, 240),
              Colors.white,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/calendar.png",
                height: 80,
                width: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Nessuna prenotazione per oggi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Prenota subito il tuo campo e organizza la tua prossima partita!",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: DrawerScreen(selectedIndex: 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 28),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/profile.png"),
                radius: 20,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
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
                  onTap: () {},
                  child: Row(
                    children: [
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 20),
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
                    onTap: () {
                      Get.to(() => CalendarPage());
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
            const SizedBox(height: 15),
            // --- CARD PROCHAINE PRENOTAZIONE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _todayReservation != null
                  ? _buildNextAppointmentCardWithData(_todayReservation!)
                  : _buildNoAppointmentCard(),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            // --- LISTE DES CAMPI ---
            SizedBox(
              height: 120,
              child: FutureBuilder<List<Campo>>(
                future: futureCampi,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.green));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Erreur : ${snapshot.error}"));
                  }
                  final campi = snapshot.data ?? [];
                  if (campi.isEmpty) {
                    return const Center(child: Text("Aucun campo trouvé"));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: campi.length,
                    itemBuilder: (context, index) {
                      final campo = campi[index];
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
                            Get.to(() => DetailsCampo(campo: campo));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 4,
                            child: Container(
                              width: 300,
                              padding: const EdgeInsets.all(10),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: campo.foto.isNotEmpty
                                        ? Image.network(
                                            campo.foto.first,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/campo.png",
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          campo.nome,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          campo.tipo,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.amber, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              campo.recensione.toString(),
                                              style: const TextStyle(
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
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
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
            barItems: [
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
