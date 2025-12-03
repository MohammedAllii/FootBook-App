import 'package:flutter/material.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/calendar/calendar_page.dart';
import 'package:footbookcamp/campo/booking_page.dart';
import 'package:footbookcamp/campo/details_campo.dart';
import 'package:footbookcamp/profile/edit_profile_page.dart';
import 'package:get/get.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class CampiList extends StatefulWidget {
  @override
  _CampiListState createState() => _CampiListState();
}

int selectedIndex = 2;

final List<Map<String, dynamic>> _campi = [
  {
    "nome": "Campo Centrale",
    "tipo": "Calcio a 11",
    "immagine": "assets/stadium.jpg",
    "valutazione": 4.6,
    "disponibile": true,
  },
  {
    "nome": "Campo Laterale",
    "tipo": "Calcio a 5",
    "immagine": "assets/stadium1.jpg",
    "valutazione": 4.5,
    "disponibile": false,
  },
  {
    "nome": "Campo Minore",
    "tipo": "Calcio a 7",
    "immagine": "assets/stadium2.jpg",
    "valutazione": 4.8,
    "disponibile": true,
  },
];

final List<Map<String, String>> _categorie = [
  {"nome": "Tutti", "immagine": "assets/categories/all.png"}, 
  {"nome": "Calcio a 5", "immagine": "assets/categories/calcio5.jpg"},
  {"nome": "Calcio a 7", "immagine": "assets/categories/calcio7.jpg"},
  {"nome": "Calcio a 11", "immagine": "assets/categories/calcio11.png"},
  {"nome": "Beach Soccer", "immagine": "assets/categories/beach.jpg"},
];

class _CampiListState extends State<CampiList> {
  String? _categoriaSelezionata = "Tutti";

  @override
  Widget build(BuildContext context) {
    final campiFiltrati = (_categoriaSelezionata == null || _categoriaSelezionata == "Tutti")
        ? _campi
        : _campi.where((campo) => campo['tipo'] == _categoriaSelezionata).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Ricerca Campi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Categories
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categorie.map((categoria) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ChoiceChip(
                    backgroundColor: Colors.white,
                    label: Row(
                      children: [
                        Image.asset(
                          categoria['immagine']!,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          categoria['nome']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    selected: _categoriaSelezionata == categoria['nome'],
                    onSelected: (selected) {
                      setState(() {
                        _categoriaSelezionata =
                            selected ? categoria['nome'] : null;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Campi list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: campiFiltrati.isEmpty
                  ? Center(
                      child: Text(
                        "Nessun campo trovato",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: campiFiltrati.length,
                      itemBuilder: (context, index) {
                        final campo = campiFiltrati[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsCampo(),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF44a4a4),
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    campo['immagine'],
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        campo['nome'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.black),
                                        ),
                                        child: Text(
                                          campo['tipo'],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(campo['valutazione'].toString()),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 18),
                                          const Spacer(),
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BookingPage()),
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.black),
                                              label: const Text(
                                                "Prenota",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
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
                        );
                      },
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
