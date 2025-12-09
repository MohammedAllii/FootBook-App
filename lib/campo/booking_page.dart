import 'package:flutter/material.dart';
import 'payment_page.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime selectedDate = DateTime.now();

  // EXEMPLE: heures déjà réservées pour le jour sélectionné
  Map<String, List<String>> bookedHoursPerDay = {
    "2025-11-27": ["09:00", "10:30", "15:00"],
    "2025-11-28": ["11:00", "13:30"]
  };

  String? selectedHour;

  // Générer toutes les heures de 09:00 à 00:00 par intervalle de 1h30
  List<String> get hours {
    List<String> result = [];
    int hour = 9;
    int minute = 0;

    while (hour < 24) {
      result.add('${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      minute += 30;
      if (minute >= 60) {
        hour += 1;
        minute -= 60;
      }
      hour += 1; // Ajouter 1h pour avoir 1h30 total
    }

    return result;
  }

  List<String> get bookedHours {
    String key = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}";
    return bookedHoursPerDay[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prenotazione"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Seleziona una data:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // ----------------- CALENDARIO -----------------
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 30)),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
              calendarFormat: CalendarFormat.week,
              availableCalendarFormats: const {
                CalendarFormat.week: 'Semaine',
              },
              onDaySelected: (day, focusedDay) {
                setState(() {
                  selectedDate = day;
                  selectedHour = null; 
                });
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Seleziona un orario:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // ----------------- LISTE DES HEURES -----------------
            Expanded(
  child: ListView.builder(
    itemCount: hours.length,
    itemBuilder: (_, i) {
      final now = DateTime.now();

      // Transformer l'heure en DateTime
      final hourParts = hours[i].split(':');
      final hourDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(hourParts[0]),
        int.parse(hourParts[1]),
      );

      // Déterminer si l'heure est déjà passée aujourd'hui
      bool isPast = selectedDate.year == now.year &&
          selectedDate.month == now.month &&
          selectedDate.day == now.day &&
          hourDateTime.isBefore(now);

      bool isBooked = bookedHours.contains(hours[i]);
      bool isDisabled = isPast || isBooked;
      bool isSelected = selectedHour == hours[i];

      return ListTile(
        title: Text(
          hours[i],
          style: TextStyle(
            color: isDisabled ? Colors.grey : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isBooked
            ? Icon(Icons.lock, color: Colors.red)
            : isPast
                ? Icon(Icons.access_time, color: Colors.orange)
                : isSelected
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : null,
        onTap: isDisabled
            ? null
            : () {
                setState(() {
                  selectedHour = hours[i];
                });
              },
      );
    },
  ),
),


            // ----------------- BOUTON PAIEMENT -----------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedHour == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentPage(
                              date: selectedDate,
                              hour: selectedHour!,
                              price: 25, campiId: 1, userId: 1,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2ECC71),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Continua al pagamento",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
