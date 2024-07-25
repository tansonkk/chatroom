import 'package:chatroom/page/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/page/ChatListPage.dart';
import 'package:chatroom/api.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loading = true;

  bool hasToken = false;

  @override
  void initState() {
    super.initState();
    verify();
  }

  void verify() async {
    hasToken = await APIS().verifyToken();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const CircularProgressIndicator();

    return hasToken ? const ChatListPage() : LoginPage();
  }
}
