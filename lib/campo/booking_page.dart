import 'package:flutter/material.dart';
import 'package:footbookcamp/Model/campi_model.dart';
import 'payment_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPage extends StatefulWidget {
  final Campo campo;

  const BookingPage({Key? key, required this.campo}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime selectedDate = DateTime.now();
  late final campo = widget.campo;

  Map<String, List<String>> bookedHoursPerDay = {};
  String? selectedHour;
  bool isLoading = true; // Flag per controllo caricamento

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
      hour += 1;
    }
    return result;
  }

  List<String> get bookedHours {
    String key =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    return bookedHoursPerDay[key] ?? [];
  }

  @override
  void initState() {
    super.initState();
    fetchBookedHours(selectedDate);
  }

  Future<void> fetchBookedHours(DateTime date) async {
    setState(() {
      isLoading = true; // Inizio caricamento
    });

    final url =
        "http://10.109.162.110:8000/api/booked-hours?campi_id=${campo.id}&data=${date.toIso8601String().substring(0, 10)}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          bookedHoursPerDay[
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"] =
              List<String>.from(data['booked_hours']);
          selectedHour = null;
          isLoading = false; // Fine caricamento
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Errore nel recuperare gli orari prenotati"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Errore di connessione: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prenotazione")),
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
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 30)),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
              calendarFormat: CalendarFormat.week,
              availableCalendarFormats: const {CalendarFormat.week: 'Semaine'},
              onDaySelected: (day, focusedDay) {
                setState(() {
                  selectedDate = day;
                  selectedHour = null;
                });
                fetchBookedHours(day);
              },
              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: Colors.green.withOpacity(0.4), shape: BoxShape.circle),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Seleziona un orario:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: hours.length,
                itemBuilder: (_, i) {
                  final now = DateTime.now();
                  final hourParts = hours[i].split(':');
                  final hourDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    int.parse(hourParts[0]),
                    int.parse(hourParts[1]),
                  );

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
            // Bottone pagamento visibile solo quando isLoading = false
            if (!isLoading)
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
                                price: 25,
                                campiId: campo.id,
                                userId: 1,
                                campiName: campo.nome,
                              ),
                            ),
                          ).then((value) {
                            // Ricaricare gli orari dopo pagamento
                            fetchBookedHours(selectedDate);
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2ECC71),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "Continua al pagamento",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
