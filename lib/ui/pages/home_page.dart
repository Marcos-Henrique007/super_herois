import 'package:flutter/material.dart';

import 'agents_page.dart';
import 'daily_contract_page.dart';
import 'mission_page.dart';
import 'squad_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  //Cria um botão do menu:
  Widget _buildMenuButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 260,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,

        //Estilo do botão:
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),

        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Título da tela:
        title: const Text(
          'Central de Heróis',
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            //Tela de agentes:
            _buildMenuButton(
              text: 'Agentes',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AgentsPage(),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 16,
            ),

            //Contrato diário:
            _buildMenuButton(
              text: 'Contrato Diário',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const DailyContractPage(),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 16,
            ),

            //Meu esquadrão:
            _buildMenuButton(
              text: 'Meu Esquadrão',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const SquadPage(),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 16,
            ),

            //Missões:
            _buildMenuButton(
              text: 'Missões',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const MissionPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}