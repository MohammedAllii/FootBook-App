import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  final DateTime date;
  final String hour;
  final double price;

  PaymentPage({
    required this.date,
    required this.hour,
    required this.price,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController cardNumberCtrl = TextEditingController();
  final TextEditingController cardHolderCtrl = TextEditingController();
  final TextEditingController expiryCtrl = TextEditingController();
  final TextEditingController cvvCtrl = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagamento"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD DESIGN
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF44a4a4).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("FOOTBOOK CARD",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 1.3,
                      )),
                  SizedBox(height: 35),
                  Text(
                    cardNumberCtrl.text.isEmpty
                        ? "XXXX XXXX XXXX XXXX"
                        : cardNumberCtrl.text,
                    style: TextStyle(
                        color: Colors.white, fontSize: 22, letterSpacing: 2),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cardHolderCtrl.text.isEmpty
                            ? "NOME TITOLARE"
                            : cardHolderCtrl.text.toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        expiryCtrl.text.isEmpty ? "MM/YY" : expiryCtrl.text,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // FORM FIELDS
            Text("Dettagli della carta",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 20),

            TextField(
              controller: cardNumberCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Numero Carta",
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),

            TextField(
              controller: cardHolderCtrl,
              decoration: InputDecoration(
                labelText: "Nome Titolare",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryCtrl,
                    decoration: InputDecoration(
                      labelText: "Scadenza (MM/YY)",
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: cvvCtrl,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "CVV",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // SUMMARY
            Text("Riepilogo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Data: ${widget.date.toString().substring(0, 10)}"),
            Text("Orario: ${widget.hour}"),
            Text("Prezzo: ${widget.price.toStringAsFixed(2)} €",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 40),

            // PAY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _payWithStripe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF44a4a4).withOpacity(0.9),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Paga Ora",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _payWithStripe() async {
    if (cardNumberCtrl.text.isEmpty ||
        cardHolderCtrl.text.isEmpty ||
        expiryCtrl.text.isEmpty ||
        cvvCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compila tutti i campi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Exemple : Appel Laravel backend pour créer un paiement Stripe
      final response = await http.post(
        Uri.parse("https://your-laravel-backend.com/api/payment"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "card_number": cardNumberCtrl.text,
          "card_holder": cardHolderCtrl.text,
          "expiry": expiryCtrl.text,
          "cvv": cvvCtrl.text,
          "amount": widget.price,
          "date": widget.date.toString(),
          "hour": widget.hour,
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pagamento completato!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Errore pagamento: ${result['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
