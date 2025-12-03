// lib/details_campo.dart
import 'dart:async';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:footbookcamp/campo/booking_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;


class DetailsCampo extends StatefulWidget {
  const DetailsCampo({Key? key}) : super(key: key);

  @override
  _DetailsCampoState createState() => _DetailsCampoState();
}

class _DetailsCampoState extends State<DetailsCampo>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.95);
  int _currentPage = 2;
  Timer? _carouselTimer;

  late final TabController _tabController;

  double _rating = 4.0;
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, dynamic>> _comments = [
    {
      "name": "Marco",
      "comment": "Campo molto pulito e ben organizzato!",
      "rating": 4.5,
    },
    {
      "name": "Luca",
      "comment": "Buona esperienza, ma l’illuminazione può migliorare.",
      "rating": 3.5,
    },
  ];

  final List<Map<String, dynamic>> _events = [
    {
      "title": "Partita amichevole",
      "date": DateTime.now(),
      "time": "18:00 - 19:00",
      "image": "assets/stadium.jpg",
    },
    {
      "title": "Allenamento",
      "date": DateTime.now().add(const Duration(days: 1)),
      "time": "20:00 - 21:00",
      "image": "assets/stadium1.jpg",
    },
  ];

static const _campoLatLng = ll.LatLng(41.902782, 12.496366);
  final Set<Marker> _markers = {};

  final List<String> _images = [
    'assets/stadium1.jpg',
    'assets/stadium.jpg',
    'assets/stadium2.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);



    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final next = (_currentPage + 1) % _images.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _tabController.dispose();
    _pageController.dispose();
    _commentController.dispose();
    super.dispose();
  }

Future<void> _launchPhoneDialer(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

  try {
    await launchUrl(
      phoneUri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Nessuna app telefono trovata")),
    );
  }
}




  Future<void> _openMaps(double lat, double lng) async {
    final Uri google = Uri.parse('google.navigation:q=$lat,$lng&mode=d');
    final Uri apple = Uri.parse('http://maps.apple.com/?daddr=$lat,$lng');

    if (await canLaunchUrl(google)) {
      await launchUrl(google);
    } else if (await canLaunchUrl(apple)) {
      await launchUrl(apple);
    } else {
      CherryToast.info(
        title: const Text('Nessuna app di navigazione trovata'),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
  backgroundColor: const Color(0xFFF6F8F7),
  body: SafeArea(
    child: Column(
      children: [
        Expanded(
          flex: isLandscape ? 5 : 3,   // ratio intelligent
          child: !isLandscape
              ? _buildTopPortrait(screenHeight)
              : _buildTopLandscape(screenWidth, screenHeight),
        ),

        Expanded(
          flex: 7,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTitleSection(),
                const SizedBox(height: 12),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _tabInfo(),
                      _tabContact(),
                      _tabReviews(),
                      _tabMap(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),

    );
  }

  // ---------------------------------------
  // BUILDER WIDGETS
  // ---------------------------------------

  Widget _buildTopPortrait(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.34,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: AssetImage(_images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 14 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? Colors.white : Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopLandscape(double screenWidth, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.45,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: AssetImage(_images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Campo Sportivo GreenPark',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Struttura moderna, ideale per tornei e allenamenti.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.green),
                      SizedBox(width: 6),
                      Expanded(child: Text('Via Roma 123, 00100 Roma')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: _rating,
                        itemBuilder:
                            (_, __) =>
                                const Icon(Icons.star, color: Colors.amber),
                        itemSize: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(_rating.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              'Campo Sportivo GreenPark',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.sports_soccer, color: Colors.green),
            SizedBox(width: 8),
            Text('Prenota il tuo campo in pochi click'),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: const Color(0xFF2ECC71),
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black54,
      tabs: const [
        Tab(icon: Icon(Icons.info), text: 'Info'),
        Tab(icon: Icon(Icons.contact_phone_outlined), text: 'Contatto'),
        Tab(icon: Icon(Icons.reviews), text: 'Recensioni'),
        Tab(icon: Icon(Icons.map), text: 'Mappa'),
      ],
    );
  }

  // ----------------------------------------------------
  // TAB INFO
  // ----------------------------------------------------
  Widget _tabInfo() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Descrizione",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Il Campo Sportivo GreenPark offre una struttura moderna, ideale per calcio, paddle e attività sportive.",
        ),
        const SizedBox(height: 16),
        const Text("Servizi", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
Wrap(
  spacing: 6,
  runSpacing: 9,
  children: [
    _buildFeatureChip("Luci Notturne"),
    _buildFeatureChip("Spogliatoi"),
    _buildFeatureChip("Bar"),
    _buildFeatureChip("Parcheggio"),
  ],
),



        const SizedBox(height: 40),

SizedBox(
  width: double.infinity,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black), // bord noir
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 40,
          offset: const Offset(0, 3), // ombre vers le bas
        ),
      ],
    ),
    child: ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookingPage()),
        );
      },
      icon: const Icon(Icons.calendar_month, color: Colors.black),
      label: const Text(
        'Prenota Ora',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0, // supprime l’ombre par défaut
      ),
    ),
  ),
),

      ],
    ),
  );
}

Widget _buildFeatureChip(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}


  // ----------------------------------------------------
  // TAB CONTACT
  // ----------------------------------------------------
  Widget _tabContact() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            elevation: 6,
            child: ListTile(
              leading: const Icon(Icons.email,color: Colors.black,),              
              title: const Text("Email",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              subtitle: const Text("greenparkcampo@gmail.com",style: TextStyle(color: Colors.black)),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(
                    const ClipboardData(text: 'greenparkcampo@gmail.com'),
                  );
                  CherryToast.info(
                    title: const Text('Email copiata!'),
                  ).show(context);
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  color: Colors.white,
  elevation: 6,
  child: ListTile(
    leading: Icon(Icons.phone, color: Colors.black),
    title: const Text(
      "Telefono",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: const Text("+39 345 678 9012"),
    trailing: ElevatedButton.icon(
      onPressed: () => _launchPhoneDialer('+393456789012'),
      icon: const Icon(Icons.call, color: Colors.black),
      label: const Text(""),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 148, 211, 137),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ),
),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // TAB REVIEWS
  // ----------------------------------------------------
  Widget _tabReviews() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ..._comments.map((c) {
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade200,
                  child: Text(c["name"][0]),
                ),
                title: Text(c["name"]),
                subtitle: Text(c["comment"]),
              ),
            );
          }).toList(),

          const SizedBox(height: 10),
          const Text(
            "Aggiungi una recensione:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
TextField(
  controller: _commentController,
  maxLines: 3,
  decoration: InputDecoration(
    hintText: "Scrivi la tua opinione...",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15), // <-- ici le border radius
      borderSide: const BorderSide(color: Colors.black), // couleur de la bordure
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.blue), // couleur quand focus
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  ),
),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            onPressed: () {
              if (_commentController.text.trim().isEmpty) {
                CherryToast.info(
                  title: const Text('Inserisci un commento'),
                ).show(context);
                return;
              }

              setState(() {
                _comments.add({
                  "name": "Giocatore",
                  "comment": _commentController.text.trim(),
                  "rating": 4.0,
                });
              });

              _commentController.clear();
              CherryToast.success(
                title: const Text('Recensione aggiunta!'),
              ).show(context);
            },
            icon: const Icon(Icons.send,color: Colors.black,),
            label: const Text("Invia",style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // TAB MAP
  // ----------------------------------------------------
 // ----------------------------------------------------
// TAB MAP
// ----------------------------------------------------
Widget _tabMap() {
  return Column(
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: ll.LatLng(
                _campoLatLng.latitude,
                _campoLatLng.longitude,
              ),
              initialZoom: 15,
            ),
            children: [
TileLayer(
  urlTemplate:
    "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=v8rM3KA53qUGAkt9eBdk",
  userAgentPackageName: 'com.hamouda.footbook',
),

              MarkerLayer(
                markers: [
                  Marker(
                    point: ll.LatLng(
                        _campoLatLng.latitude, _campoLatLng.longitude),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              // REQUIRED BY OSM
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    '© OpenStreetMap contributors',
                    onTap: null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 10),

SizedBox(
  width: double.infinity,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 4,
          blurRadius: 10,
          offset: const Offset(12, 0), 
        ),
      ],
    ),
    child: ElevatedButton.icon(
      onPressed: () {
        _openMaps(
          _campoLatLng.latitude,
          _campoLatLng.longitude,
        );
      },
      icon: const Icon(Icons.directions),
      label: const Text(
        "Itinéraire",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0, // on supprime l'ombre par défaut de l’ElevatedButton
      ),
    ),
  ),
),

    ],
  );
}



}
