import 'package:flutter/material.dart';
import 'package:flutter_smart_recycle/screens/auth_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主页'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              // 返回登录页
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => AuthScreen())
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text('欢迎登录'),
      ),
    );
  }
} 