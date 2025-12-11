import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/perfil.png"),
            ),
            SizedBox(height: 16),
            Text(
              'Carol Santos',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 5),
            Text(
              '@carol_santos',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '100',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(width: 80),
                Text(
                  '10K',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(width: 80),
                Text(
                  '80K',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Seguindo',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(width: 50),
                Text(
                  'Seguidores',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(width: 50),
                Text(
                  'Curtidas',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                )
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image.asset("assets/images/foto1.png"),
              SizedBox(width: 10),
              Image.asset("assets/images/foto2.png"),],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image.asset("assets/images/foto3.png"),
              SizedBox(width: 10),
              Image.asset("assets/images/foto4.png"),],
            )
          ],
        ),
      ),
    );
  }
}