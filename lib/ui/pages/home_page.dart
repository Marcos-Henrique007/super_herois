import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text(
          'Home Page',
        ),
      ),
    );
  }
}