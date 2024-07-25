import 'package:chatroom/page/ForgotPassWord.dart';

import 'package:chatroom/page/Login_page.dart';
import 'package:chatroom/page/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/page/AuthPage.dart';
import 'package:chatroom/page/ChatListPage.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/chatlist': (context) => const ChatListPage(),
        '/home': (context) => const AuthPage(),
        '/forgotpassword': (context) => const ForgotPassWord(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
