import 'package:firebase_backend/pages/login_page.dart';
import 'package:firebase_backend/pages/register_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isShowwingLoginPage = true;

  void toggleScreens() {
    setState(() {
      isShowwingLoginPage = !isShowwingLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isShowwingLoginPage) {
      return LoginPage(showRegisterPage: toggleScreens);
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
