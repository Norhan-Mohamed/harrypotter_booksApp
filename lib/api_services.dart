import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();
  String baseUrl = "https://potterapi-fedeperin.vercel.app/en";


  Future<List<dynamic>?> getBooks() async {
    try {
      final response = await dio.get("$baseUrl/books");

      print("Books fetched successfully");
      return response.data;
    } catch (e) {
      print("Error fetching books: $e");
      return null;
    }
  }

  Future<List<dynamic>?> getCharacters() async {
    try {
      final response = await dio.get("$baseUrl/characters");

      print("Characters fetched successfully");
      return response.data;
    } catch (e) {
      print("Error fetching characters: $e");
      return null;
    }
  }

}
