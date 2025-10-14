part of 'character_cubit.dart';

abstract class CharacterState {}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<dynamic> characters;
  CharacterLoaded(this.characters);
}

class CharacterError extends CharacterState {
  final String message;
  CharacterError(this.message);
}
