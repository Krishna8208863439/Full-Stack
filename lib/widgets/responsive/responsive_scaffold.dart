import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../features/authentication/providers/auth_provider.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveBreakpoints {
  static const double mobileMax = 599.0;
  static const double tabletMax = 1023.0;

  static DeviceType getDeviceType(double width) {
    if (width <= mobileMax) return DeviceType.mobile;
    if (width <= tabletMax) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}

class ResponsiveScaffold extends ConsumerStatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  ConsumerState<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends ConsumerState<ResponsiveScaffold> {
  int _selectedRailIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final width = MediaQuery.of(context).size.width;
    final deviceType = ResponsiveBreakpoints.getDeviceType(width);
    final currentRoute = GoRouterState.of(context).uri.toString();

    // Mobile Layout: Top AppBar + Drawer + Bottom Navigation
    if (deviceType == DeviceType.mobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          actions: widget.actions,
        ),
        drawer: _buildDrawer(context, user, currentRoute),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _getBottomNavIndex(currentRoute),
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.secondarySlate,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => _onBottomNavTapped(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.precision_manufacturing_outlined), label: 'Looms'),
            BottomNavigationBarItem(icon: Icon(Icons.line_weight_outlined), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stock'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
        body: SafeArea(child: widget.body),
      );
    }

    // Tablet Layout: Navigation Rail + Top AppBar + Body
    if (deviceType == DeviceType.tablet) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              _buildRoleBadge(user?.role),
            ],
          ),
          actions: widget.actions,
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedRailIndex,
              onDestinationSelected: (int index) {
                setState(() => _selectedRailIndex = index);
                _onRailTapped(context, index);
              },
              labelType: NavigationRailLabelType.selected,
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryBlue,
                radius: 18,
                child: Icon(Icons.factory, size: 20, color: Colors.white),
              ),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
                NavigationRailDestination(icon: Icon(Icons.precision_manufacturing_outlined), selectedIcon: Icon(Icons.precision_manufacturing), label: Text('Looms')),
                NavigationRailDestination(icon: Icon(Icons.line_weight_outlined), selectedIcon: Icon(Icons.line_weight), label: Text('Orders')),
                NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: Text('Stock')),
                NavigationRailDestination(icon: Icon(Icons.verified_outlined), selectedIcon: Icon(Icons.verified), label: Text('Quality')),
                NavigationRailDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: Text('Maintenance')),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1, color: AppColors.borderLight),
            Expanded(child: widget.body),
          ],
        ),
      );
    }

    // Desktop & Web Layout (1024px+): Persistent Sidebar + Top Bar
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
            const SizedBox(width: 12),
            _buildRoleBadge(user?.role),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.secondarySlate),
            onPressed: () => context.go(AppRoutes.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.secondarySlate),
            onPressed: () => context.go(AppRoutes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.statusDanger),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
          ),
          if (widget.actions != null) ...widget.actions!,
          const SizedBox(width: 12),
        ],
      ),
      drawer: _buildDrawer(context, user, currentRoute),
      body: SafeArea(child: widget.body),
    );
  }

  Widget _buildRoleBadge(String? role) {
    final displayRole = (role ?? 'ADMIN').toUpperCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
      ),
      child: Text(
        displayRole,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, dynamic user, String currentRoute) {
    return Drawer(
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
                _navTile(context, 'Executive Dashboard', Icons.dashboard_outlined, AppRoutes.adminDashboard, currentRoute),
                _navTile(context, 'Worker Floor Dashboard', Icons.badge_outlined, AppRoutes.workerDashboard, currentRoute),
                _navTile(context, 'Live Machine Telemetry', Icons.precision_manufacturing_outlined, AppRoutes.machines, currentRoute),
                _navTile(context, 'Production Management', Icons.line_weight_outlined, AppRoutes.production, currentRoute),
                _navTile(context, 'Yarn & Fabric Stock', Icons.inventory_2_outlined, AppRoutes.inventory, currentRoute),
                _navTile(context, 'Quality Control (ASTM)', Icons.verified_outlined, AppRoutes.quality, currentRoute),
                _navTile(context, 'Maintenance & Tickets', Icons.build_outlined, AppRoutes.maintenance, currentRoute),
                _navTile(context, 'Workforce Attendance', Icons.how_to_reg_outlined, AppRoutes.attendance, currentRoute),
                _navTile(context, 'Enterprise Reports', Icons.assessment_outlined, AppRoutes.reports, currentRoute),
                _navTile(context, 'Mill Settings & Logs', Icons.settings_outlined, AppRoutes.settings, currentRoute),
                _navTile(context, 'My Profile', Icons.person_outline, AppRoutes.profile, currentRoute),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navTile(BuildContext context, String label, IconData icon, String route, String currentRoute) {
    final isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primaryBlue : AppColors.secondarySlate, size: 22),
      title: Text(label, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? AppColors.primaryBlue : AppColors.textDark)),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }

  int _getBottomNavIndex(String route) {
    if (route == AppRoutes.machines) return 1;
    if (route == AppRoutes.production) return 2;
    if (route == AppRoutes.inventory) return 3;
    if (route == AppRoutes.profile) return 4;
    return 0;
  }

  void _onBottomNavTapped(BuildContext context, int index) {
    switch (index) {
      case 0: context.go(AppRoutes.adminDashboard); break;
      case 1: context.go(AppRoutes.machines); break;
      case 2: context.go(AppRoutes.production); break;
      case 3: context.go(AppRoutes.inventory); break;
      case 4: context.go(AppRoutes.profile); break;
    }
  }

  void _onRailTapped(BuildContext context, int index) {
    switch (index) {
      case 0: context.go(AppRoutes.adminDashboard); break;
      case 1: context.go(AppRoutes.machines); break;
      case 2: context.go(AppRoutes.production); break;
      case 3: context.go(AppRoutes.inventory); break;
      case 4: context.go(AppRoutes.quality); break;
      case 5: context.go(AppRoutes.maintenance); break;
    }
  }
}
