part of 'books_cubit.dart';

sealed class BooksState {
  const BooksState();
}

class BooksInitial extends BooksState {
  const BooksInitial();
}

class BooksLoading extends BooksState {
  const BooksLoading();
}

class BooksLoaded extends BooksState {
  const BooksLoaded(this.books);

  final List<Book> books;
}

class BooksEmpty extends BooksState {
  const BooksEmpty();
}

class BooksError extends BooksState {
  const BooksError(this.message);

  final String message;
}
