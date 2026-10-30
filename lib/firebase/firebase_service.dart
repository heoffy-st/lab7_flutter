import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../firebase_options.dart';

class FirebaseService {
  // Инициализация Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Подключение к Realtime Database
  static final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://laboratory-7-86f30-default-rtdb.europe-west1.firebasedatabase.app',
  );

  // Получение ссылки на базу данных
  static DatabaseReference get usersReference {
    return database.ref('users');
  }
}
