import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';
import '../../authentication/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return MainLayoutShell(
      title: 'User Profile & Active Sessions',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primaryBlue,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.displayName ?? 'Rajesh Kumar', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        Text(user?.email ?? 'admin@texmill-erp.com', style: const TextStyle(color: AppColors.secondarySlate, fontSize: 13)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text('ROLE: ${user?.roleId.toUpperCase() ?? "ADMIN"}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Active Security Sessions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const Divider(height: 20),
                    const ListTile(
                      leading: Icon(Icons.desktop_windows, color: AppColors.primaryBlue),
                      title: Text('Windows Desktop Workstation • Current Session'),
                      subtitle: Text('IP: 192.168.1.45 • Signed in 2 hours ago'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.smartphone, color: AppColors.secondarySlate),
                      title: Text('Android Floor Tablet • Maintenance Room'),
                      subtitle: Text('IP: 192.168.1.88 • Active 1 day ago'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
