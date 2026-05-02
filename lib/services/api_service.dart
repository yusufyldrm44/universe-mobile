import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/constants.dart';

typedef UnauthorizedHandler = Future<void> Function();

class ApiService {
  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kApiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: kTokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final cb = _onUnauthorized;
            if (cb != null) {
              await cb();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  static final ApiService instance = ApiService._internal();

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UnauthorizedHandler? _onUnauthorized;

  Dio get dio => _dio;

  void registerUnauthorizedHandler(UnauthorizedHandler handler) {
    _onUnauthorized = handler;
  }

  String extractErrorMessage(Object error, [String fallback = 'Bir hata oluştu']) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] is String) {
        return data['message'] as String;
      }
      if (data is Map && data['error'] is String) {
        return data['error'] as String;
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Bağlantı zaman aşımına uğradı';
        case DioExceptionType.connectionError:
          return 'Sunucuya bağlanılamadı';
        default:
          break;
      }
      if (error.message != null && error.message!.isNotEmpty) {
        return error.message!;
      }
    }
    return fallback;
  }
}
