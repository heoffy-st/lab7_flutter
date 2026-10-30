class UserModel {
  final String uid;
  final String name;
  final String email;
  final String createdAt;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.fcmToken,
  });

  // Преобразование объекта в Map для Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt,
      if (fcmToken != null) 'fcmToken': fcmToken,
    };
  }

  // Создание объекта из данных Firebase
  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'] ?? '',
      fcmToken: map['fcmToken'],
    );
  }
}
