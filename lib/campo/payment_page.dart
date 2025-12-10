import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:footbookcamp/Home/HomeScreen.dart';
import 'package:footbookcamp/campo/details_campo.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  final int campiId;
  final int userId;
  final DateTime date;
  final String hour;
  final String campiName;
  final double price;

  const PaymentPage({
    super.key,
    required this.campiId,
    required this.userId,
    required this.date,
    required this.hour,
    required this.campiName,
    required this.price,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;

  Future<void> _startPayment() async {
  setState(() => isLoading = true);

  try {
    final response = await http.post(
      Uri.parse("http://10.109.162.110:8000/api/create-payment-intent"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "campi_id": widget.campiId,
        "user_id": widget.userId,
        "data": widget.date.toString().substring(0, 10),
        "ora": widget.hour,
        "prezzo": widget.price,
      }),
    );

    final data = jsonDecode(response.body);

    // ⚠️ Si réservation déjà faite ou slot occupé
    if (response.statusCode != 200 || data["status"] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Errore prenotazione"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      // Redirection vers les détails du campo
      Navigator.pop(context, true); 
      return;
    }

    // Paiement Stripe
    final clientSecret = data["client_secret"];

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Football Booking",
        style: ThemeMode.light,
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pagamento riuscito ✓"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

Navigator.pop(context, true); 

  } catch (e) {
    if (e is StripeException) {
      if (e.error.code == "Canceled" ||
          e.error.localizedMessage?.toLowerCase().contains("cancel") == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pagamento annullato"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Hai già prenotato questo orario"),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 2),
  ),
);

  } finally {
    setState(() => isLoading = false);
  }
}


  // --------------------- UI ------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "Pagamento",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      // ---- HERE : scrollable body ----
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ---------------- CARD Informations -----------------
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calendar_month, color: Colors.blueAccent, size: 28),
                      SizedBox(width: 12),
                      Text(
                        "Dettagli Prenotazione",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  infoRow(Icons.date_range, "Data", widget.date.toString().substring(0, 10)),
                  divider(),
                  infoRow(Icons.access_time, "Orario", widget.hour),
                  divider(),
                  infoRow(Icons.sports_soccer, "Campo", widget.campiName.toString()),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- CARD Prix -----------------
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7F5FFF), Color(0xFF5A3FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 14,
                    spreadRadius: 1,
                    offset: Offset(0, 6),
                  )
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Prezzo totale",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${widget.price.toStringAsFixed(2)} €",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ---------------- BUTTON -----------------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: Icon(Icons.credit_card, color: Colors.white),
                onPressed: isLoading ? null : _startPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5A3FFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 8,
                ),
                label: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Paga con Stripe",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widgets réutilisables
  Widget infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 26),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "$title :",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        )
      ],
    );
  }

  Widget divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: Colors.grey.shade300),
      );
}
