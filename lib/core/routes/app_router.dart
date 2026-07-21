import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/views/login_screen.dart';
import '../../features/dashboard/views/dashboard_screen.dart';
import '../../features/machine_monitoring/views/machine_monitoring_screen.dart';
import '../../features/production/views/production_screen.dart';
import '../../features/inventory/views/inventory_screen.dart';
import '../../features/quality/views/quality_screen.dart';
import '../../features/maintenance/views/maintenance_screen.dart';
import '../../features/attendance/views/attendance_screen.dart';
import '../../features/reports/views/reports_screen.dart';
import '../../features/notifications/views/notifications_screen.dart';
import '../../features/settings/views/settings_screen.dart';
import '../../features/profile/views/profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String machines = '/machines';
  static const String production = '/production';
  static const String inventory = '/inventory';
  static const String quality = '/quality';
  static const String maintenance = '/maintenance';
  static const String attendance = '/attendance';
  static const String reports = '/reports';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String profile = '/profile';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.machines,
      builder: (context, state) => const MachineMonitoringScreen(),
    ),
    GoRoute(
      path: AppRoutes.production,
      builder: (context, state) => const ProductionScreen(),
    ),
    GoRoute(
      path: AppRoutes.inventory,
      builder: (context, state) => const InventoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.quality,
      builder: (context, state) => const QualityScreen(),
    ),
    GoRoute(
      path: AppRoutes.maintenance,
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(
      path: AppRoutes.attendance,
      builder: (context, state) => const AttendanceScreen(),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
