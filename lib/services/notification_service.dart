import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../firebase/firebase_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Замени IP на IPv4-адрес своего компьютера
  static const String serverUrl = 'http://10.238.233.63:3000';

  String? _currentUid;

  Future<void> initialize() async {
    // Запрашиваем разрешение на уведомления
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Регистрируем устройство
    await _messaging.register();

    // Получаем FCM-токен
    _messaging.onRegistered.listen((token) async {
      debugPrint('Получен FCM-токен');

      if (_currentUid != null) {
        await _saveTokenToDatabase(_currentUid!, token);
      }
    });

    // Обработка уведомлений в открытом приложении
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Уведомление: ${message.notification?.title}');

      debugPrint('Текст: ${message.notification?.body}');
    });

    // Обработка нажатия на уведомление
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Пользователь открыл уведомление');
    });
  }

  // Получение и сохранение токена после регистрации
  Future<String> saveToken(String uid) async {
    _currentUid = uid;

    final tokenFuture = _messaging.onRegistered.first;

    await _messaging.register();

    final token = await tokenFuture;

    await _saveTokenToDatabase(uid, token);

    return token;
  }

  // Сохранение токена в Firebase Realtime Database
  Future<void> _saveTokenToDatabase(String uid, String token) async {
    await FirebaseService.usersReference.child(uid).update({'fcmToken': token});

    debugPrint('FCM-токен сохранён в Firebase');
  }

  // Отслеживание обновления токена
  void listenTokenRefresh(String uid) {
    _currentUid = uid;
  }

  // Отправка уведомления после регистрации
  Future<void> sendRegistrationNotification({
    required String token,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse('$serverUrl/send-registration-notification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка отправки уведомления: ${response.body}');
    }

    debugPrint('Уведомление после регистрации отправлено');
  }
}
