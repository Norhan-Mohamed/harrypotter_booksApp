import 'package:dio/dio.dart';

import '../models/book.dart';
import '../models/character.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                responseType: ResponseType.json,
              ),
            );

  static const String _baseUrl = 'https://potterapi-fedeperin.vercel.app/en';

  final Dio _dio;

  Future<List<Book>> getBooks() async {
    try {
      final response = await _dio.get<List<dynamic>>('/books');
      final data = response.data;

      if (data == null) {
        throw const ApiException('No books were returned.');
      }

      return data
          .whereType<Map>()
          .map((item) => Book.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (error) {
      throw ApiException(_messageFromDio(error, 'books'));
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Could not load books. Please try again.');
    }
  }

  Future<List<Character>> getCharacters() async {
    try {
      final response = await _dio.get<List<dynamic>>('/characters');
      final data = response.data;

      if (data == null) {
        throw const ApiException('No characters were returned.');
      }

      return data
          .whereType<Map>()
          .map((item) => Character.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (error) {
      throw ApiException(_messageFromDio(error, 'characters'));
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Could not load characters. Please try again.');
    }
  }

  String _messageFromDio(DioException error, String resource) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out while loading $resource.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Check your network and try again.';
      case DioExceptionType.badResponse:
        return 'Server error while loading $resource.';
      default:
        return 'Could not load $resource. Please try again.';
    }
  }
}
