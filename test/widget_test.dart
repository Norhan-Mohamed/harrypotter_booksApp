import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harrypotter/cubit/books_cubit.dart';
import 'package:harrypotter/models/book.dart';
import 'package:harrypotter/models/character.dart';
import 'package:harrypotter/screens/home_screen.dart';
import 'package:harrypotter/services/api_service.dart';

void main() {
  group('Book', () {
    test('parses json with expected fields', () {
      final book = Book.fromJson({
        'number': 1,
        'title': "Harry Potter and the Sorcerer's Stone",
        'originalTitle': "Harry Potter and the Sorcerer's Stone",
        'releaseDate': 'Jun 26, 1997',
        'description': 'The first book.',
        'pages': 223,
        'cover': 'https://example.com/cover.png',
      });

      expect(book.number, 1);
      expect(book.title, contains("Sorcerer's Stone"));
      expect(book.pages, 223);
    });

    test('uses safe defaults for missing fields', () {
      final book = Book.fromJson({});

      expect(book.title, 'Untitled');
      expect(book.pages, 0);
      expect(book.cover, isEmpty);
    });
  });

  group('Character', () {
    test('parses json with children list', () {
      final character = Character.fromJson({
        'fullName': 'Harry James Potter',
        'nickname': 'Harry',
        'hogwartsHouse': 'Gryffindor',
        'interpretedBy': 'Daniel Radcliffe',
        'children': ['James Sirius Potter'],
        'image': 'https://example.com/harry.png',
        'birthdate': 'Jul 31, 1980',
      });

      expect(character.fullName, 'Harry James Potter');
      expect(character.children, ['James Sirius Potter']);
      expect(character.hogwartsHouse, 'Gryffindor');
    });
  });

  group('HomeScreen', () {
    testWidgets('shows loaded books and retry on error', (tester) async {
      final api = _FakeApiService(books: [
        const Book(
          number: 1,
          title: 'Test Book One',
          originalTitle: 'Test Book One',
          releaseDate: 'Jun 26, 1997',
          description: 'A test description.',
          pages: 200,
          cover: '',
        ),
      ]);

      await tester.pumpWidget(
        RepositoryProvider<ApiService>.value(
          value: api,
          child: BlocProvider(
            create: (context) =>
                BooksCubit(context.read<ApiService>())..fetchBooks(),
            child: const MaterialApp(home: HomeScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Book One'), findsOneWidget);
      expect(find.text('Book 1'), findsOneWidget);
    });

    testWidgets('shows error state with retry', (tester) async {
      final api = _FakeApiService(shouldFail: true);

      await tester.pumpWidget(
        RepositoryProvider<ApiService>.value(
          value: api,
          child: BlocProvider(
            create: (context) =>
                BooksCubit(context.read<ApiService>())..fetchBooks(),
            child: const MaterialApp(home: HomeScreen()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });
  });
}

class _FakeApiService extends ApiService {
  _FakeApiService({
    this.books = const [],
    this.shouldFail = false,
  });

  final List<Book> books;
  final bool shouldFail;

  @override
  Future<List<Book>> getBooks() async {
    if (shouldFail) {
      throw const ApiException('Network unavailable');
    }
    return books;
  }

  @override
  Future<List<Character>> getCharacters() async => const [];
}
