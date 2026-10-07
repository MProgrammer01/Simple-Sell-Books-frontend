import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sell_your_books/Core/Values/typography.dart';
import 'package:sell_your_books/Features/Auth/Views/sign_in_screen.dart';
import 'package:sell_your_books/Features/Auth/cubit/auth_cubit.dart';
import 'package:sell_your_books/Features/books/cubit/book_cubit.dart';
import 'package:sell_your_books/Features/global/data/connection_to_api.dart';
import 'package:sell_your_books/Features/settings/cubit/settings_cubit.dart';
import 'package:sell_your_books/navigation_between_screens.dart';

void main() {
   ClsConnectionToAPI.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
          BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
          ),
           BlocProvider<BookCubit>(
            create: (_) => BookCubit(),
          ),
          BlocProvider<SettingsCubit>(
            create: (_) => SettingsCubit(),
          ),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          extensions: [TypographyApp.instance],
        ),
        onGenerateRoute: ClsNavigationBetweenScreens.generateRoute,
        home: const SignInScreen(),
      ),
    );
  }
}
