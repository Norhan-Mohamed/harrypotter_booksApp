import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/books_cubit.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HarryPotterApp());
}

class HarryPotterApp extends StatelessWidget {
  const HarryPotterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ApiService(),
      child: BlocProvider(
        create: (context) => BooksCubit(context.read<ApiService>())..fetchBooks(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Harry Potter Books',
          theme: AppTheme.dark(),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
