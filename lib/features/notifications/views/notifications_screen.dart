import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = [
      {'title': 'CRITICAL: Loom AJ-004 Stopped > 30 Mins', 'body': 'Machine breakdown ticket #TCK-401 logged automatically. Motor fault detected.', 'time': '10 mins ago', 'icon': Icons.error_outline, 'color': AppColors.statusDanger},
      {'title': 'WARNING: Yarn Stock Reorder Alert', 'body': 'Yarn Lot YN-4082 (150D Poly) reached reorder level (850 Kg remaining).', 'time': '42 mins ago', 'icon': Icons.warning_amber, 'color': AppColors.statusWarning},
      {'title': 'INFO: Production Order Completed', 'body': 'Order PO-9902 (20,000 meters) completed with 98.4% Grade A yield.', 'time': '2 hours ago', 'icon': Icons.check_circle_outline, 'color': AppColors.statusSuccess},
    ];

    return MainLayoutShell(
      title: 'Real-Time Notifications & Ticker Feed',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemCount: alerts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = alerts[index];
            final color = item['color'] as Color;

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(item['icon'] as IconData, color: color, size: 22),
                ),
                title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(item['body'] as String, style: const TextStyle(fontSize: 12, color: AppColors.secondarySlate)),
                trailing: Text(item['time'] as String, style: const TextStyle(fontSize: 11, color: AppColors.secondarySlate)),
              ),
            );
          },
        ),
      ),
    );
  }
}
