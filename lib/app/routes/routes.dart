import 'package:contacts/app/bloc/app_bloc.dart';
import 'package:contacts/features/home/view/home_page.dart';
import 'package:contacts/features/login/view/login_page.dart';
import 'package:flutter/widgets.dart';

List<Page<void>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
    // ignore: no_default_cases
    default:
      return [LoginPage.page()];
  }
}
