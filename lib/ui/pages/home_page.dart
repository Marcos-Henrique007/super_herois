import 'package:flutter/material.dart';

import 'agents_page.dart';
import 'daily_contract_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Título da tela:
        title: const Text(
          'Central de Heróis',
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              //Abre a tela de agentes:
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AgentsPage(),
                  ),
                );
              },
              child: const Text(
                'Agentes',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton(
              //Abre o contrato diário:
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const DailyContractPage(),
                  ),
                );
              },
              child: const Text(
                'Contrato Diário',
              ),
            ),
          ],
        ),
      ),
    );
  }
}