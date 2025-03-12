import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/ui/pages.dart';
import 'package:flutter/material.dart';

import 'ui/ui/attedance/attendance/attendance_page.dart';
import 'ui/ui/attedance/history/history_page.dart';
import 'ui/ui/attedance/leave/leave_page.dart';
import 'ui/ui/attedance/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    webProvider: ReCaptchaV3Provider('D2D99CD2-D51F-4D80-82DB-9EFA211E58CC'),
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  runApp(const MyApp());
}

// D2D99CD2-D51F-4D80-82DB-9EFA211E58CC

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => SignInPage(),
        '/register': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/noted': (context) => NotedPage(),
        '/profile' : (context) => ProfilePage(),
        '/change-password' : (context) => ChangePasswordPage(),
        '/attendance' : (context) => AttendancePage(),
        '/attendance/history' : (context) => HistoryPage(),
        '/attendance/leave' : (context) => LeavePage(),
        '/attendance/main' : (context) => MainPage(),
      },
    );
  }
}
