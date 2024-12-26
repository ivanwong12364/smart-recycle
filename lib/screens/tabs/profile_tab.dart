import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileTab extends StatelessWidget {
  final AuthService _authService = AuthService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  String get _userInitials {
    if (_currentUser?.displayName?.isNotEmpty ?? false) {
      final names = _currentUser!.displayName!.split(' ');
      if (names.length > 1) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return names[0][0].toUpperCase();
    }
    return _currentUser?.email?[0].toUpperCase() ?? 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 用户信息卡片
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // 头像
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFFE6D5BA),
                          backgroundImage: _currentUser?.photoURL != null
                              ? NetworkImage(_currentUser!.photoURL!)
                              : null,
                          child: _currentUser?.photoURL == null
                              ? Text(
                                  _userInitials,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 16),
                        // 用户名和邮箱
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUser?.displayName ?? 'User',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _currentUser?.email ?? '',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
                // GENERAL 部分
                Text(
                  'GENERAL',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.grey,
                    ),
                    title: Text('Version'),
                    trailing: Text(
                      '1.0.0',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // ACCOUNT 部分
                Text(
                  'ACCOUNT',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Sign out',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      await _authService.signOut();
                      Navigator.of(context).pushReplacementNamed('/auth');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 