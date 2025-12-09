import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  final int campiId;
  final int userId;
  final DateTime date;
  final String hour;
  final double price;

  PaymentPage({
    required this.campiId,
    required this.userId,
    required this.date,
    required this.hour,
    required this.price,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;

  /// 🔵 Fonction principale : créer PaymentIntent → saisir la carte → confirmer paiement
  Future<void> _startPayment() async {
    try {
      setState(() => isLoading = true);

      // 1️⃣ APPEL API Laravel → création PaymentIntent
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

      if (response.statusCode != 200) {
        throw data["message"] ?? "Erreur backend Laravel";
      }

      final clientSecret = data["client_secret"];

      // 2️⃣ SAISIE DE CARTE → Stripe PaymentSheet (méthode recommandée 2025)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Football Booking",
          style: ThemeMode.light,
        ),
      );

      // 3️⃣ Ouvrir PaymentSheet Stripe
      await Stripe.instance.presentPaymentSheet();

      // 4️⃣ SUCCESS
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Paiement réussi ✓"),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pagamento Stripe")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Data: ${widget.date.toString().substring(0, 10)}"),
            Text("Orario: ${widget.hour}"),
            SizedBox(height: 15),

            Text("Prezzo:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("${widget.price.toStringAsFixed(2)} €",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _startPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Paga con Stripe",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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
}
