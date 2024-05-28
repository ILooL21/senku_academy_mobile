import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/profile_screen.dart';
import 'screen/home.dart';
import 'screen/category_detail_screen.dart';
import 'screen/lesson_detail_screen.dart';
import 'screen/chapter_detail_screen.dart';
import 'screen/exercise_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
        path: '/category/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CategoryDetailScreen(id: id);
        }),
    GoRoute(
        path: '/lesson/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return LessonDetailScreen(id: id);
        }),
    GoRoute(
        path: '/chapter/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChapterDetailScreen(id: id);
        }),
    GoRoute(
        path: '/question/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ExerciseDetailScreen(id: id);
        }),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Senku Academy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
