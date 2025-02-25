import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;

  ApiClient({
    required String baseUrl,
    required Logger logger,
  })  : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        ),
        _logger = logger {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i(
              'Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e(
              'Error: ${e.response?.statusCode} ${e.requestOptions.path}\n${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.statusMessage ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return RequestCancelledException();
      default:
        return NetworkException(e.message ?? 'Network error');
    }
  }
}

class TimeoutException implements Exception {
  final String message = 'Connection timeout';
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class RequestCancelledException implements Exception {
  final String message = 'Request cancelled';
}
