import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_api.dart';
import 'login_page.dart';

/// 登录后的简易首页：展示当前用户信息，验证整条链路。
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.loginResult});

  static const routeName = '/home';

  final LoginResult loginResult;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = AuthApi();
  late Future<User> _meFuture;

  @override
  void initState() {
    super.initState();
    _meFuture = _api.me(widget.loginResult.token);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = widget.loginResult.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('智慧儿童心理保健系统'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context, rootNavigator: true)
                .pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('退出登录'),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            scheme.primary.withValues(alpha: 0.12),
                        child: Text(
                          user.realName.isNotEmpty
                              ? user.realName.characters.first
                              : '?',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.realName,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          user.roleName,
                          style: TextStyle(
                              color: scheme.primary, fontSize: 12.5),
                        ),
                      ),
                      const Divider(height: 32),
                      _infoRow(Icons.badge_outlined, '用户名', user.username),
                      _infoRow(Icons.tag_rounded, '角色编码', user.roleCode),
                      if (user.phone != null)
                        _infoRow(Icons.phone_outlined, '联系电话', user.phone!),
                      _infoRow(Icons.schedule_rounded, '最近登录',
                          user.lastLoginAt ?? '刚刚'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified_rounded,
                              color: scheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('会话令牌校验（GET /api/auth/me）',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<User>(
                        future: _meFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              '✓ 令牌有效，服务端返回：'
                              '${snapshot.data!.realName}（${snapshot.data!.roleName}）',
                              style: TextStyle(
                                  color: scheme.primary, fontSize: 13.5),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text(
                              '✗ 校验失败：${snapshot.error}',
                              style: TextStyle(
                                  color: scheme.error, fontSize: 13.5),
                            );
                          }
                          return const SizedBox(
                            height: 18,
                            width: 18,
                            child:
                                CircularProgressIndicator(strokeWidth: 2.2),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: Text(label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 14.5),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
