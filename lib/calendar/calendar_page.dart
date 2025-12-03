import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/campo/campi_list.dart';
import 'package:footbookcamp/profile/edit_profile_page.dart';
import 'package:get/get.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  int selectedIndex = 1;

  /// --- EVENTS SUR DIFFÉRENTS JOURS ---
  final Map<DateTime, List<String>> events = {
    DateTime(2025, 11, 29): ["Partita amichevole", "Allenamento"],
    DateTime(2025, 11, 27): ["Torneo 5v5"],
    DateTime(2025, 11, 27): ["Prenotazione campo"],
    DateTime(2025, 11, 30): ["Allenamento ragazzi U17"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Calendario Prenotazioni",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// --- CALENDRIER ---
          CalendarTimeline(
            initialDate: _selectedDate,
            firstDate: DateTime(2024, 1, 1),
            lastDate: DateTime(2030, 12, 31),
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            leftMargin: 30,
            monthColor: Colors.black,
            dayColor: Colors.black,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.black,
            dotColor: Colors.blue,
            eventDates: events.keys.toList(),
            locale: "it",
          ),

          const SizedBox(height: 20),

          /// --- ZONE ÉVÉNEMENTS ---
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: _buildEvents(),
            ),
          ),
        ],
      ),

      backgroundColor: Colors.white,

      /// --- NAVIGATION BAR ---
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

  /// --- AFFICHER LES EVENT DU JOUR ---
  Widget _buildEvents() {
    final dayEvents = events.entries
        .where((e) =>
            e.key.year == _selectedDate.year &&
            e.key.month == _selectedDate.month &&
            e.key.day == _selectedDate.day)
        .map((e) => e.value)
        .expand((i) => i)
        .toList();

    if (dayEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.event_busy, size: 60, color: Colors.black),
            SizedBox(height: 10),
            Text(
              "Nessun evento per questa data",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        return _EventSwipeCard(
          title: dayEvents[index],
          imageUrl:
              "https://images.pexels.com/photos/399187/pexels-photo-399187.jpeg?auto=compress",
          onCancel: () {
            print("Event canceled: ${dayEvents[index]}");
          },
        );
      },
    );
  }
}

///////////////////////////////////////////////////////////////////
///              --- WIDGET : SWIPE CARD ---                   ///
///////////////////////////////////////////////////////////////////

class _EventSwipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Function() onCancel;

  const _EventSwipeCard({
    required this.title,
    required this.imageUrl,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),

      /// Swipe left only
      direction: DismissDirection.endToStart,

      /// Background red with text "Annulla"
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          "Annulla",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// Confirmation popup
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Conferma"),
            content: const Text("Vuoi annullare questa prenotazione?"),
            actions: [
              TextButton(
                child: const Text("No"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Sì"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );
      },

      /// Action after dismiss
      onDismissed: (direction) => onCancel(),

      /// Main card
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: Row(
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            /// Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
