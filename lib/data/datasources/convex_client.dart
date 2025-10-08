import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';

/// Custom Convex client for Flutter
/// Connects directly to Convex backend using HTTP API
class ConvexClient {
  final Dio _dio;
  final String baseUrl;

  ConvexClient({String? baseUrl})
      : baseUrl = baseUrl ?? EnvConfig.convexUrl,
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? EnvConfig.convexUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  /// Query data from Convex (READ operations)
  ///
  /// Example:
  /// ```dart
  /// final users = await convex.query('users.getAllVerifiedUsers', {});
  /// ```
  /// Note: Dot notation will be converted to colon notation for Convex HTTP API
  Future<T> query<T>(String functionName, [Map<String, dynamic>? args]) async {
    try {
      // Convert dot notation to colon notation for Convex HTTP API
      // e.g., "streamCards.getAllStreamCards" -> "streamCards:getAllStreamCards"
      final convexPath = functionName.replaceAll('.', ':');

      final response = await _dio.post(
        '/api/query',
        data: {
          'path': convexPath,
          'args': args ?? {},
        },
      );

      // Convex HTTP API wraps responses in {"status": "success", "value": ...}
      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'success') {
        return data['value'] as T;
      } else {
        throw ConvexException(
          'Query returned error status: ${data['status']}',
        );
      }
    } on DioException catch (e) {
      throw ConvexException(
        'Query failed: $functionName',
        originalError: e,
      );
    }
  }

  /// Mutate data in Convex (WRITE operations)
  ///
  /// Example:
  /// ```dart
  /// await convex.mutate('users/updateCard', {
  ///   'twitterId': '123',
  ///   'badge': 'Streamer',
  /// });
  /// ```
  Future<T> mutate<T>(String path, Map<String, dynamic> args) async {
    try {
      final response = await _dio.post(
        '/api/convex/$path',
        data: args,
      );

      return response.data as T;
    } on DioException catch (e) {
      throw ConvexException(
        'Mutation failed: $path',
        originalError: e,
      );
    }
  }

  /// Get file URL from Convex storage directly
  Future<String?> getFileUrl(String storageId) async {
    try {
      // Call Convex storage.getUrl query directly
      final result = await query<String?>(
        'storage.getUrl',
        {'storageId': storageId},
      );
      return result;
    } on DioException catch (e) {
      throw ConvexException(
        'Failed to get file URL for: $storageId',
        originalError: e,
      );
    }
  }

  /// Generate upload URL for file storage
  Future<String> generateUploadUrl() async {
    try {
      final response = await _dio.post('/api/convex/generate-upload-url');
      return response.data['uploadUrl'] as String;
    } on DioException catch (e) {
      throw ConvexException(
        'Failed to generate upload URL',
        originalError: e,
      );
    }
  }

  /// Upload file to Convex storage
  Future<String> uploadFile(
    String uploadUrl,
    List<int> fileBytes,
    String mimeType,
  ) async {
    try {
      final response = await _dio.post(
        uploadUrl,
        data: fileBytes,
        options: Options(
          headers: {'Content-Type': mimeType},
        ),
      );

      return response.data['storageId'] as String;
    } on DioException catch (e) {
      throw ConvexException(
        'File upload failed',
        originalError: e,
      );
    }
  }

  void dispose() {
    _dio.close();
  }
}

/// Custom exception for Convex operations
class ConvexException implements Exception {
  final String message;
  final Object? originalError;

  ConvexException(this.message, {this.originalError});

  @override
  String toString() {
    if (originalError != null) {
      return 'ConvexException: $message\nCaused by: $originalError';
    }
    return 'ConvexException: $message';
  }
}
