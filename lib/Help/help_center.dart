import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:footbookcamp/Help/about/InfoPageModern.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

int selectedIndex = 6;

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Centro Aiuto",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow:  [
                  BoxShadow(
                    color: Color(0xFF44a4a4).withOpacity(0.6),
                    blurRadius: 6.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help_outline,
                      size: 32.sp, color: const Color(0xFF44a4a4).withOpacity(0.6)),
                  SizedBox(width: 10.w),
                  const Text(
                    "Domande Frequenti",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // GRID HELP SECTIONS
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18.w,
                mainAxisSpacing: 20.h,
                childAspectRatio: 1,
              ),
              itemCount: _items().length,
              itemBuilder: (context, index) {
                final item = _items()[index];

                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item['route']),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(120, 72, 179, 106),
                          blurRadius: 5.0,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'],
                            size: 50.sp, color: const Color(0xFF44a4a4).withOpacity(0.6)),
                        SizedBox(height: 10.h),
                        Text(
                          item['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

 List<Map<String, dynamic>> _items() {
  return [
    {
      'title': "Chi Siamo",
      'icon': Icons.info_outline,
      'route': InfoPageModern(
        title: "Chi Siamo",
        steps: [
          "FootBook è un'app semplice per consultare i campi di calcio disponibili.",
          "Il nostro obiettivo è offrire un'esperienza veloce e intuitiva.",
          "Ideale per giocatori singoli o gruppi che vogliono prenotare un campo.",
          "Siamo sempre disponibili per suggerimenti o domande.",
        ],
        icon: Icons.info_outline,
      ),
    },
    {
      'title': "Regole del Campo",
      'icon': Icons.sports_soccer,
      'route': InfoPageModern(
        title: "Regole del Campo",
        steps: [
          "Rispettare gli orari di prenotazione.",
          "Indossare scarpe e abbigliamento sportivo.",
          "Non introdurre cibi o bevande in campo.",
          "Vietato fumare o consumare alcolici.",
          "Lasciare il campo pulito dopo l'uso.",
        ],
        icon: Icons.sports_soccer,
      ),
    },
    {
      'title': "Come Prenotare",
      'icon': Icons.book_online,
      'route': InfoPageModern(
        title: "Come Prenotare",
        steps: [
          "Apri FootBook e seleziona 'Trova un campo'.",
          "Scegli data e orario disponibili.",
          "Vai alla pagina di pagamento.",
          "Completa la prenotazione tramite Stripe.",
        ],
        icon: Icons.book_online,
      ),
    },
    {
      'title': "Pagamenti & Stripe",
      'icon': Icons.credit_card,
      'route': InfoPageModern(
        title: "Pagamenti & Stripe",
        steps: [
          "Seleziona l'orario che vuoi prenotare.",
          "Inserisci i dati della tua carta tramite Stripe.",
          "Conferma il pagamento in modo sicuro.",
          "Il campo sarà considerato prenotato subito dopo il pagamento.",
        ],
        icon: Icons.credit_card,
      ),
    },
    {
      'title': "Account & Profilo",
      'icon': Icons.person_outline,
      'route': InfoPageModern(
        title: "Account & Profilo",
        steps: [
          "Accedi al tuo account FootBook.",
          "Modifica informazioni personali e password.",
          "Gestisci le tue preferenze.",
          "Consulta i dati del tuo profilo in qualsiasi momento.",
        ],
        icon: Icons.person_outline,
      ),
    },
    {
      'title': "Termini e Privacy",
      'icon': Icons.privacy_tip_outlined,
      'route': InfoPageModern(
        title: "Termini e Privacy",
        steps: [
          "L'uso dell'app segue i Termini di Servizio.",
          "La privacy è gestita secondo il GDPR.",
          "I tuoi dati non vengono condivisi senza consenso.",
          "Per maggiori dettagli consulta l'informativa completa.",
        ],
        icon: Icons.privacy_tip_outlined,
      ),
    },
  ];
}


}

class InfoPage extends StatelessWidget {
  final String title;
  final List<String> steps;
  final IconData icon;

  const InfoPage({
    super.key,
    required this.title,
    required this.steps,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 60, color: Colors.green),
            const SizedBox(height: 16),
            ...steps.map((step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    step,
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
