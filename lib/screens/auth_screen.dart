import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget{
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(),
    );
  }
}

