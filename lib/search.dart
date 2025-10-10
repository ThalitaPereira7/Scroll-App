import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Tela de Busca',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}