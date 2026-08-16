part of 'characters_cubit.dart';

sealed class CharactersState {
  const CharactersState();
}

class CharactersInitial extends CharactersState {
  const CharactersInitial();
}

class CharactersLoading extends CharactersState {
  const CharactersLoading();
}

class CharactersLoaded extends CharactersState {
  const CharactersLoaded(this.characters);

  final List<Character> characters;
}

class CharactersEmpty extends CharactersState {
  const CharactersEmpty();
}

class CharactersError extends CharactersState {
  const CharactersError(this.message);

  final String message;
}
