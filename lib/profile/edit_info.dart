import 'package:flutter/material.dart';
import 'package:footbookcamp/Services/AuthService.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({super.key});

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final AuthService _authService = AuthService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cognomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _indirizzoController = TextEditingController();
  final TextEditingController _etaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? avatar;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // ================================================================
  // 🔄 Charger les infos utilisateur
  // ================================================================
  Future<void> _loadUserInfo() async {
  try {
    final user = await _authService.getUser();
    if (user["error"] == true) {
      throw Exception(user["message"]);
    }
    if (mounted) {
      setState(() {
        _nomeController.text = user["nome"] ?? "";
        _cognomeController.text = user["cognome"] ?? "";
        _emailController.text = user["email"] ?? "";
        _telefonoController.text = user["telefono"] ?? "";
        _indirizzoController.text = user["indirizzo"] ?? "";
        _etaController.text = user["eta"]?.toString() ?? "";
      });
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Errore nel caricamento dei dati: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  // ================================================================
  // 🔄 Mettre à jour le profil
  // ================================================================
  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    // Vérification password
    if (_passwordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Le password non coincidono."),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }
    }

final data = {
  if (_nomeController.text.isNotEmpty) "nome": _nomeController.text,
  if (_cognomeController.text.isNotEmpty) "cognome": _cognomeController.text,
  if (_emailController.text.isNotEmpty) "email": _emailController.text,
  if (_telefonoController.text.isNotEmpty) "telefono": _telefonoController.text,
  if (_indirizzoController.text.isNotEmpty) "indirizzo": _indirizzoController.text,
  if (_etaController.text.isNotEmpty) "eta": int.tryParse(_etaController.text),
  if (_passwordController.text.isNotEmpty) "password": _passwordController.text,
};


    if (_passwordController.text.isNotEmpty) {
      data["password"] = _passwordController.text;
    }

    try {
      final res = await _authService.updateProfile(data);
      setState(() => _isLoading = false);

      if (res["error"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res["message"] ?? "Errore sconosciuto"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profilo aggiornato con successo!"),
          backgroundColor: Colors.green,
        ),
      );

      // Optionnel : recharger les données après update
      _loadUserInfo();
      _passwordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Errore durante l'aggiornamento."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================================================================
  // 🟦 Input Widget
  // ================================================================
  Widget _buildInput(TextEditingController controller, String label, IconData icon,
      {bool isNumber = false, bool obscure = false}) {
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
        obscureText: obscure,
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

  // ================================================================
  // 🟦 Build Page
  // ================================================================
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profilo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Avatar + Infos
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
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        "${_nomeController.text} ${_cognomeController.text}",
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(39, 105, 171, 1),
                        ),
                      ),
                      const Divider(thickness: 2.5),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.email, color: Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            _emailController.text,
                            style: const TextStyle(fontSize: 15),
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
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: avatar != null
                          ? NetworkImage(avatar!)
                          : const AssetImage("assets/profile.png") as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Nome + Cognome
            Row(
              children: [
                Expanded(
                    child: _buildInput(_nomeController, "Nome", Icons.person)),
                const SizedBox(width: 10),
                Expanded(
                    child:
                        _buildInput(_cognomeController, "Cognome", Icons.person_outline)),
              ],
            ),

            // Email
            _buildInput(_emailController, "Email", Icons.email),

            // Telefono + Età
            Row(
              children: [
                Expanded(
                    child: _buildInput(_telefonoController, "Telefono", Icons.phone,
                        isNumber: true)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildInput(_etaController, "Età", Icons.cake,
                        isNumber: true)),
              ],
            ),

            // Indirizzo
            _buildInput(_indirizzoController, "Indirizzo", Icons.location_on),

            // Password
            _buildInput(_passwordController, "Nuova Password", Icons.lock, obscure: true),
            _buildInput(_confirmPasswordController, "Conferma Password", Icons.lock_outline,
                obscure: true),

            const SizedBox(height: 30),

            // Button Update
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _updateProfile,
                icon: const Icon(Icons.update, color: Colors.white),
                label: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        "Aggiorna",
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF44a4a4).withOpacity(0.9),
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
