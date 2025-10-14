
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api_services.dart';

part 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final ApiService apiService;
  CharacterCubit(this.apiService) : super(CharacterInitial());

  Future<void> fetchCharacters() async {
    try {
      emit(CharacterLoading());
      final characters = await apiService.getCharacters();

      if (characters == null) {
        emit(CharacterError("Failed to load characters"));
      } else {
        emit(CharacterLoaded(characters));
      }
    } catch (e) {
      emit(CharacterError(e.toString()));
    }
  }
}
