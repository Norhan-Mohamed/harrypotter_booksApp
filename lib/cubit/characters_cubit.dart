import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/character.dart';
import '../services/api_service.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(this._apiService) : super(const CharactersInitial());

  final ApiService _apiService;

  Future<void> fetchCharacters() async {
    emit(const CharactersLoading());

    try {
      final characters = await _apiService.getCharacters();
      if (characters.isEmpty) {
        emit(const CharactersEmpty());
      } else {
        emit(CharactersLoaded(characters));
      }
    } on ApiException catch (error) {
      emit(CharactersError(error.message));
    } catch (_) {
      emit(const CharactersError('Could not load characters. Please try again.'));
    }
  }
}
