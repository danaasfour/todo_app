import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tzl;
import 'package:todoa_app/models/database_provider.dart';
import 'package:todoa_app/models/notification_service.dart';
import 'package:todoa_app/views/screens/home_screen.dart';
import 'package:todoa_app/views/screens/login_screen.dart';
import 'package:todoa_app/views/screens/new_task_screen.dart';
import 'package:todoa_app/views/screens/signup_screen.dart';
import 'package:todoa_app/views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tzl.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(
            create: (context) => DatabaseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.orange, accentColor: Colors.indigo),
          appBarTheme: const AppBarTheme(
              color: Colors.indigo, foregroundColor: Colors.white),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                const Color(0xff6da5c7),
              ), //text (and icon)
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith<EdgeInsets>((_) =>
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (_) => Colors.white),
                  shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (_) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))))),
          inputDecorationTheme: const InputDecorationTheme(
            iconColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          textTheme: const TextTheme(
            subtitle1: TextStyle(color: Colors.white),
          )),
      home: const SplashScreen(),
      routes: {
        SignUpScreen.route: (context) => const SignUpScreen(),
        LoginScreen.route: (context) => const LoginScreen(),
        HomeScreen.route: (context) => const HomeScreen(),
        NewTaskScreen.route: (context) => const NewTaskScreen(),
      },
    );
  }
}
