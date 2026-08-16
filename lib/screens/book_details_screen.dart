import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/characters_cubit.dart';
import '../models/book.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_network_image.dart';
import '../widgets/character_card.dart';
import '../widgets/status_view.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CharactersCubit(context.read<ApiService>())..fetchCharacters(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text(book.title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: AppNetworkImage(
                  url: book.cover,
                  width: 200,
                  height: 300,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                book.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
              if (book.originalTitle.isNotEmpty &&
                  book.originalTitle != book.title) ...[
                const SizedBox(height: 8),
                Text(
                  book.originalTitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  _InfoChip(
                    icon: Icons.event_rounded,
                    label: book.releaseDate,
                  ),
                  _InfoChip(
                    icon: Icons.menu_book_rounded,
                    label: '${book.pages} pages',
                  ),
                  _InfoChip(
                    icon: Icons.tag_rounded,
                    label: 'Book ${book.number}',
                  ),
                ],
              ),
              if (book.description.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Synopsis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  book.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
              const SizedBox(height: 28),
              const Text(
                'Series Characters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Browse characters from the wizarding world.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 14),
              const _CharactersSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CharactersSection extends StatelessWidget {
  const _CharactersSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        return switch (state) {
          CharactersInitial() || CharactersLoading() => const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(child: CircularProgressIndicator()),
            ),
          CharactersError(:final message) => StatusView.error(
              message: message,
              onRetry: () => context.read<CharactersCubit>().fetchCharacters(),
            ),
          CharactersEmpty() => StatusView.empty(
              title: 'No characters found',
              onRetry: () => context.read<CharactersCubit>().fetchCharacters(),
            ),
          CharactersLoaded(:final characters) => SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: characters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return GestureDetector(
                    onTap: () => _showCharacterSheet(context, character),
                    child: CharacterCard(character: character),
                  );
                },
              ),
            ),
        };
      },
    );
  }

  void _showCharacterSheet(BuildContext context, Character character) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              AppNetworkImage(
                url: character.image,
                width: 96,
                height: 96,
                placeholderIcon: Icons.person_rounded,
                borderRadius: BorderRadius.circular(48),
              ),
              const SizedBox(height: 16),
              Text(
                character.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (character.nickname.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '"${character.nickname}"',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  if (character.hogwartsHouse.isNotEmpty)
                    _InfoChip(
                      icon: Icons.home_rounded,
                      label: character.hogwartsHouse,
                    ),
                  if (character.birthdate.isNotEmpty)
                    _InfoChip(
                      icon: Icons.cake_rounded,
                      label: character.birthdate,
                    ),
                ],
              ),
              if (character.interpretedBy.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Portrayed by ${character.interpretedBy}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
