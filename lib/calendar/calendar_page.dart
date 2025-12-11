import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/campo/campi_list.dart';
import 'package:footbookcamp/profile/edit_profile_page.dart';
import 'package:footbookcamp/Services/reservation_service.dart';
import 'package:footbookcamp/Model/prenotazione_model.dart';
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

  final ReservationService _reservationService = ReservationService();
  List<Prenotazione> _userReservations = [];

  @override
  void initState() {
    super.initState();
    _loadUserReservations();
  }

  void _loadUserReservations() async {
    final reservations = await _reservationService.getUserReservations(1); 
    setState(() {
      _userReservations = reservations;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventDates = _userReservations
        .map((r) => DateTime.parse(r.data))
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Calendario Prenotazioni",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            CalendarTimeline(
              initialDate: _selectedDate,
              firstDate: DateTime(2024, 1, 1),
              lastDate: DateTime(2030, 12, 31),
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              leftMargin: 5,
              dayColor: Colors.black54,
              activeDayColor: Colors.white,              
              activeBackgroundDayColor: Colors.black,
              dotColor: Colors.blue,
              showYears: false,
              height: 70,
              fontSize: 12,
              shrinkFontSize: 10,
              dayNameFontSize: 10,
              eventDates: eventDates,
              locale: "it",
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(10),
              child: _buildEvents(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
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

  Widget _buildEvents() {
    final dayReservations = _userReservations.where((r) {
      final resDate = DateTime.parse(r.data);
      return resDate.year == _selectedDate.year &&
          resDate.month == _selectedDate.month &&
          resDate.day == _selectedDate.day;
    }).toList();

    if (dayReservations.isEmpty) {
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

    return Column(
      children: dayReservations
          .map((res) => _ReservationCard(reservation: res))
          .toList(),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Prenotazione reservation;

  const _ReservationCard({required this.reservation, super.key});

  @override
  Widget build(BuildContext context) {
    final reservationDateTime = DateTime.parse(reservation.data)
        .add(_parseTime(reservation.ora));
    final isPassed = reservationDateTime.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                reservation.campo != null && reservation.campo!.foto.isNotEmpty
                    ? reservation.campo!.foto.first
                    : "https://p.turbosquid.com/ts-thumb/hM/H8rGSK/EJ6PUsDS/1/png/1604002263/1920x1080/fit_q87/004626f535c9736df93f8b2bffc7b15fba66ec1b/1.jpg",
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              reservation.campo?.nome ?? 'Campo',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildBadge(
                  Icons.access_time,
                  "${reservation.ora} • ${isPassed ? 'Passato' : 'Prossimo'}",
                  isPassed,
                ),
                _buildBadge(Icons.sports_soccer,
                    reservation.campo?.tipo ?? 'Tipo sconosciuto', isPassed),
                _buildBadge(Icons.euro, "${reservation.prezzo.toStringAsFixed(2)}€", isPassed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Duration _parseTime(String hour) {
    final parts = hour.split(":");
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return Duration(hours: h, minutes: m);
  }

  Widget _buildBadge(IconData icon, String text, bool isPassed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPassed ? Colors.grey.shade300 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isPassed ? Colors.grey : Colors.green),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
