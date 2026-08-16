import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/book.dart';
import '../services/api_service.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit(this._apiService) : super(const BooksInitial());

  final ApiService _apiService;

  Future<void> fetchBooks({bool isRefresh = false}) async {
    if (!isRefresh || state is! BooksLoaded) {
      emit(const BooksLoading());
    }

    try {
      final books = await _apiService.getBooks();
      if (books.isEmpty) {
        emit(const BooksEmpty());
      } else {
        emit(BooksLoaded(books));
      }
    } on ApiException catch (error) {
      emit(BooksError(error.message));
    } catch (_) {
      emit(const BooksError('Could not load books. Please try again.'));
    }
  }
}
