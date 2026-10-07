import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/strings.dart';
import 'package:sell_your_books/Features/Auth/Views/sign_in_screen.dart';
import 'package:sell_your_books/Features/Auth/Views/sign_up_screen.dart';
import 'package:sell_your_books/Features/books/views/add_or_edit_book_screen.dart';
import 'package:sell_your_books/Features/books/views/show_book_details_screen.dart';
import 'package:sell_your_books/Features/dashboard/views/main_dashboard.dart';

class ClsNavigationBetweenScreens {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ClsStingsApp.signInScreen:
        return MaterialPageRoute(builder: (_) => SignInScreen());

      case ClsStingsApp.signUpScreen:
        return MaterialPageRoute(builder: (_) => SignUpScreen());

      case ClsStingsApp.dashboardScreen:
        return MaterialPageRoute(builder: (_) => MainDashboardScreen());

      case ClsStingsApp.addOrEditBookScreen:
        final bookId = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => AddOrEditBookScreen(bookID: bookId ?? 0),
        );

      case ClsStingsApp.showBookDetailsScreen:
        final bookId = settings.arguments as int;

        return MaterialPageRoute(builder: (_) => ShowBookDetailsScreen(bookID: bookId));
    }
    return null;
  }
}
