import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/error_dialog.dart';

class AuthForm extends StatefulWidget {
  final AuthService authService;

  const AuthForm({Key? key, required this.authService}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _username = '';

  void _switchAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      if (_isLogin) {
        await widget.authService.signIn(_email, _password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登录成功')),
        );
      } else {
        await widget.authService.signUp(_email, _password, _username);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('注册成功')),
        );
      }
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('username'),
                  decoration: InputDecoration(labelText: '用户名'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4) {
                      return '用户名至少4个字符';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                ),
              TextFormField(
                key: ValueKey('email'),
                decoration: InputDecoration(labelText: '邮箱'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return '请输入有效的邮箱地址';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                key: ValueKey('password'),
                decoration: InputDecoration(labelText: '密码'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 7) {
                    return '密码至少7个字符';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                child: Text(_isLogin ? '登录' : '注册'),
                onPressed: _submitForm,
              ),
              TextButton(
                child: Text(_isLogin 
                  ? '创建新账号' 
                  : '已有账号？去登录'),
                onPressed: _switchAuthMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}