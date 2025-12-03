import 'package:flutter/material.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({super.key});

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cognomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _indirizzoController = TextEditingController();
  final TextEditingController _etaController = TextEditingController();

  Widget _buildInput(TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF44a4a4).withOpacity(0.9),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.teal),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilo",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            /// 🖼️ Immagine statica
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF44a4a4).withOpacity(0.9),
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      SizedBox(height: 50),
                      Text(
                        'HamouDa Mejri',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(39, 105, 171, 1),
                        ),
                      ),
                      Divider(thickness: 2.5),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            'mejrihamouda8@gmail.com',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -50,
                  left: width / 2 - 70,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/profile.png"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Nome e Cognome sulla stessa riga
            Row(
              children: [
                Expanded(
                    child: _buildInput(_nomeController, "Nome", Icons.person)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildInput(_cognomeController, "Cognome", Icons.person_outline)),
              ],
            ),

            /// Email
            _buildInput(_emailController, "Email", Icons.email),

            /// Telefono e Età sulla stessa riga
            Row(
              children: [
                Expanded(
                    child: _buildInput(_telefonoController, "Telefono", Icons.phone, isNumber: true)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildInput(_etaController, "Età", Icons.cake, isNumber: true)),
              ],
            ),

            /// Indirizzo
            _buildInput(_indirizzoController, "Indirizzo", Icons.location_on),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                },
                icon: const Icon(Icons.update, color: Colors.white),
                label: const Text(
                  "Aggiorna",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xFF44a4a4).withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
