// auth_service.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> login(String username, String password) async {
    try {
      // Buscar usuário no Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      // Verificar se encontrou algum usuário
      if (querySnapshot.docs.isNotEmpty) {  
        return true;
      }
      return false;
    } catch (e) {
      log('Erro no login: $e');
      return false;
    }
  }
}