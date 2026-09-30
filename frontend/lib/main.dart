import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AiCMHCSApp());
}

/// 智慧儿童心理保健系统（AiCMHCS）Web 前端。
class AiCMHCSApp extends StatelessWidget {
  const AiCMHCSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智慧儿童心理保健系统',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginPage(),
    );
  }
}
