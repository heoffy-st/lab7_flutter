import 'package:firebase_auth/firebase_auth.dart';

import '../firebase/firebase_service.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Регистрация нового пользователя
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // 1. Создание аккаунта в Firebase Authentication
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user!;

    // 2. Сохранение имени в Firebase Authentication
    await user.updateDisplayName(name.trim());

    // 3. Создание модели пользователя
    final userModel = UserModel(
      uid: user.uid,
      name: name.trim(),
      email: email.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );

    // 4. Сохранение данных в Realtime Database
    await FirebaseService.usersReference.child(user.uid).set(userModel.toMap());

    return userModel;
  }

  // Получение текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Выход из аккаунта
  Future<void> logout() async {
    await _auth.signOut();
  }
}
