import 'package:commute/UI/screen.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: '/main', page: () => MainScreen()),
  GetPage(name: '/profile', page: () => MainScreen()),
  GetPage(name: '/register', page: () => RegisterScreen())
];
