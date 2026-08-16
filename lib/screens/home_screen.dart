import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/books_cubit.dart';
import '../models/book.dart';
import '../theme/app_theme.dart';
import '../widgets/book_card.dart';
import '../widgets/status_view.dart';
import 'book_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text(
          'Harry Potter Books',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<BooksCubit, BooksState>(
        builder: (context, state) {
          return switch (state) {
            BooksInitial() || BooksLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            BooksError(:final message) => StatusView.error(
                message: message,
                onRetry: () => context.read<BooksCubit>().fetchBooks(),
              ),
            BooksEmpty() => StatusView.empty(
                title: 'No books found',
                message: 'The library came back empty.',
                onRetry: () => context.read<BooksCubit>().fetchBooks(),
              ),
            BooksLoaded(:final books) => _BooksGrid(books: books),
          };
        },
      ),
    );
  }
}

class _BooksGrid extends StatelessWidget {
  const _BooksGrid({required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 600
                ? 3
                : 2;

        return RefreshIndicator(
          color: AppTheme.accent,
          onRefresh: () =>
              context.read<BooksCubit>().fetchBooks(isRefresh: true),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: books.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                book: book,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookDetailsScreen(book: book),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
