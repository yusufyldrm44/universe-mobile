import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/constants.dart';
import 'api_service.dart';

class AppUser {
  final int? id;
  final String fullName;
  final String universityEmail;
  final String university;
  final String department;
  final String? createdAt;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.universityEmail,
    required this.university,
    required this.department,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      fullName: json['full_name']?.toString() ?? '',
      universityEmail: json['university_email']?.toString() ?? '',
      university: json['university']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'university_email': universityEmail,
        'university': university,
        'department': department,
        'created_at': createdAt,
      };
}

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthService extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiService _api = ApiService.instance;

  AuthStatus _status = AuthStatus.unknown;
  AppUser? _user;
  String? _token;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthService() {
    _api.registerUnauthorizedHandler(_handleUnauthorized);
  }

  Future<void> bootstrap() async {
    try {
      final token = await _storage
          .read(key: kTokenKey)
          .timeout(const Duration(seconds: 2));

      if (token != null && token.isNotEmpty) {
        _token = token;
        _status = AuthStatus.authenticated;

        // Kullanıcı verisini arka planda sessizce yükle
        _loadCachedUser();
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  void _loadCachedUser() async {
    try {
      final userRaw = await _storage
          .read(key: kUserKey)
          .timeout(const Duration(seconds: 2));
      if (userRaw != null) {
        _user = AppUser.fromJson(
          jsonDecode(userRaw) as Map<String, dynamic>,
        );
        notifyListeners();
      }
    } catch (_) {
      // Kullanıcı verisi yoksa sorun yok, token yeterli
    }
  }

  void forceUnauthenticated() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> login({
    required String universityEmail,
    required String password,
  }) async {
    final response = await _api.dio.post(
      '/auth/login',
      data: {
        'university_email': universityEmail.trim(),
        'password': password,
      },
    );
    await _persistAuth(response.data as Map<String, dynamic>);
  }

  Future<void> register({
    required String fullName,
    required String universityEmail,
    required String password,
    required String university,
    required String department,
  }) async {
    final response = await _api.dio.post(
      '/auth/register',
      data: {
        'full_name': fullName.trim(),
        'university_email': universityEmail.trim(),
        'password': password,
        'university': university.trim(),
        'department': department.trim(),
      },
    );
    await _persistAuth(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _storage.delete(key: kTokenKey);
    await _storage.delete(key: kUserKey);
    _token = null;
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> _persistAuth(Map<String, dynamic> data) async {
    final token = data['token']?.toString();
    final userMap = data['user'] as Map<String, dynamic>?;
    if (token == null || token.isEmpty || userMap == null) {
      throw StateError('Geçersiz sunucu cevabı');
    }
    _token = token;
    _user = AppUser.fromJson(userMap);
    _status = AuthStatus.authenticated;
    await _storage.write(key: kTokenKey, value: token);
    await _storage.write(key: kUserKey, value: jsonEncode(_user!.toJson()));
    notifyListeners();
  }

  Future<void> _handleUnauthorized() async {
    if (_status == AuthStatus.unauthenticated) return;
    await logout();
  }
}
