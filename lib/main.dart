import 'package:bkk/modules/Profile%20Screen/profile_screen.dart';
import 'package:bkk/modules/Register%20Screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'modules/Login Screen/login_screen.dart';
import 'modules/Job Screen/job_screen.dart';
import 'modules/Detail Job Screen/inside_job_screen.dart';
import 'modules/Alumni Screen/alumni_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Portal App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/job': (context) => const JobScreen(),
        '/insideJob': (context) => InsideJobScreen(
          job: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
        ),
        '/alumni': (context) => const AlumniScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}