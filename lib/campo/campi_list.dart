import 'package:flutter/material.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/Services/campi_service.dart';
import 'package:footbookcamp/calendar/calendar_page.dart';
import 'package:footbookcamp/campo/booking_page.dart';
import 'package:footbookcamp/campo/details_campo.dart';
import 'package:footbookcamp/profile/edit_profile_page.dart';
import 'package:footbookcamp/Model/campi_model.dart';
import 'package:get/get.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class CampiList extends StatefulWidget {
  @override
  _CampiListState createState() => _CampiListState();
}

int selectedIndex = 2;

class _CampiListState extends State<CampiList> {
  final CampiService _campiService = CampiService();

  List<Campo> _campi = [];
  String? _categoriaSelezionata = "Tutti";
  bool _isLoading = true;

  final List<Map<String, String>> _categorie = [
    {"nome": "Tutti", "immagine": "assets/categories/all.png"},
    {"nome": "Calcio a 5", "immagine": "assets/categories/calcio5.jpg"},
    {"nome": "Calcio a 7", "immagine": "assets/categories/calcio7.jpg"},
    {"nome": "Calcio a 11", "immagine": "assets/categories/calcio11.png"},
    {"nome": "Beach Soccer", "immagine": "assets/categories/beach.jpg"},
  ];

  @override
  void initState() {
    super.initState();
    fetchCampi();
  }

  Future<void> fetchCampi() async {
    try {
      final data = await _campiService.getAllCampi();
      setState(() {
        _campi = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Erreur : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
final campiFiltrati = (_categoriaSelezionata == "Tutti")
    ? _campi
    : _campi.where((campo) {
        final tipo = (campo.tipo ?? '').toString().toLowerCase();
        final cat  = (_categoriaSelezionata ?? '').toLowerCase();

        // cas spécifiques : si la catégorie contient "5" on accepte tout ce qui parle de 5
        if (cat.contains('5')) {
          return tipo.contains('5') || tipo.contains('5x5') || tipo.contains('calcio a 5') || tipo.contains('5v5');
        }
        if (cat.contains('7')) {
          return tipo.contains('7') || tipo.contains('7x7') || tipo.contains('calcio a 7');
        }
        if (cat.contains('11')) {
          return tipo.contains('11') || tipo.contains('11x11') || tipo.contains('calcio a 11');
        }

        // fallback : recherche partielle
        return tipo.contains(cat) || cat.contains(tipo);
      }).toList();


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Ricerca Campi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : Column(
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
                                  selected ? categoria['nome'] : "Tutti";
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
                                  Get.to(() => DetailsCampo(campo: campo));
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
                                        child: Image.network(
                                          campo.foto.isNotEmpty
                                              ? campo.foto.first
                                              : "https://via.placeholder.com/150",
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              campo.nome,
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
                                                campo.tipo,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(campo.recensione.toString()),
                                                const Icon(Icons.star,
                                                    color: Colors.amber, size: 18),
                                                const Spacer(),
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    Get.to(() => BookingPage(campo: campo));
                                                  },
                                                  icon: const Icon(Icons.calendar_today,
                                                      color: Colors.black),
                                                  label: const Text(
                                                    "Prenota",
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
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

      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
    );
  }
}
