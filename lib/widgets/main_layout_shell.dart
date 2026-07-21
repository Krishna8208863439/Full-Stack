import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/routes/app_router.dart';
import '../features/authentication/providers/auth_provider.dart';

class MainLayoutShell extends ConsumerWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const MainLayoutShell({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
              ),
              child: Text(
                user?.roleId.toUpperCase() ?? 'ADMIN',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.secondarySlate),
            onPressed: () => context.go(AppRoutes.notifications),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.secondarySlate),
            onPressed: () => context.go(AppRoutes.profile),
            tooltip: 'User Profile',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.statusDanger),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            tooltip: 'Logout',
          ),
          if (actions != null) ...actions!,
          const SizedBox(width: 12),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.surfaceDark),
              accountName: Text(user?.displayName ?? 'Rajesh Kumar', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              accountEmail: Text(user?.email ?? 'admin@texmill-erp.com', style: const TextStyle(color: AppColors.borderLight, fontSize: 12)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: AppColors.primaryBlue,
                child: Icon(Icons.factory_outlined, color: Colors.white, size: 28),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _navTile(context, 'Executive Dashboard', Icons.dashboard_outlined, AppRoutes.dashboard, currentRoute),
                  _navTile(context, 'Live Machine Telemetry', Icons.precision_manufacturing_outlined, AppRoutes.machines, currentRoute),
                  _navTile(context, 'Production Management', Icons.line_weight_outlined, AppRoutes.production, currentRoute),
                  _navTile(context, 'Yarn & Fabric Stock', Icons.inventory_2_outlined, AppRoutes.inventory, currentRoute),
                  _navTile(context, 'Quality Control (ASTM)', Icons.verified_outlined, AppRoutes.quality, currentRoute),
                  _navTile(context, 'Maintenance & Tickets', Icons.build_outlined, AppRoutes.maintenance, currentRoute),
                  _navTile(context, 'Workforce & Attendance', Icons.badge_outlined, AppRoutes.attendance, currentRoute),
                  _navTile(context, 'Enterprise Reports', Icons.assessment_outlined, AppRoutes.reports, currentRoute),
                  _navTile(context, 'Notifications Center', Icons.notifications_active_outlined, AppRoutes.notifications, currentRoute),
                  const Divider(color: AppColors.borderLight),
                  _navTile(context, 'Mill Settings & Logs', Icons.settings_outlined, AppRoutes.settings, currentRoute),
                  _navTile(context, 'My Profile & Security', Icons.person_outline, AppRoutes.profile, currentRoute),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('TexMill ERP v1.0.0 • Industrial Build', style: TextStyle(fontSize: 10, color: AppColors.secondarySlate)),
            ),
          ],
        ),
      ),
      body: SafeArea(child: body),
    );
  }

  Widget _navTile(BuildContext context, String label, IconData icon, String route, String currentRoute) {
    final isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primaryBlue : AppColors.secondarySlate, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? AppColors.primaryBlue : AppColors.textDark,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primaryBlue.withOpacity(0.08),
      onTap: () {
        Navigator.pop(context); // Close drawer
        context.go(route);
      },
    );
  }
}
