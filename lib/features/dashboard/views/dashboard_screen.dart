import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../widgets/main_layout_shell.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutShell(
      title: 'Executive Industrial Dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Factory Executive KPI Cards Bar
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.8 : 1.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _kpiCard('ACTIVE LOOMS', '48 / 50', '96% Operating Rate', Icons.precision_manufacturing, AppColors.statusSuccess),
                    _kpiCard('FACTORY EFFICIENCY', '88.4%', '+2.1% Shift Target', Icons.speed, AppColors.primaryBlue),
                    _kpiCard('TODAY PRODUCTION', '14,280 m', 'Target: 15,000 m', Icons.line_weight, AppColors.statusInfo),
                    _kpiCard('DEFECT RATE', '1.2%', 'ASTM 4-Point Standard', Icons.verified, AppColors.statusWarning),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Quick Actions Toolbar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.production),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Production Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.quality),
                    icon: const Icon(Icons.fact_check_outlined, size: 18),
                    label: const Text('Inspect Fabric Roll'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.maintenance),
                    icon: const Icon(Icons.build_outlined, size: 18),
                    label: const Text('Log Breakdown Ticket'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.inventory),
                    icon: const Icon(Icons.qr_code_scanner, size: 18),
                    label: const Text('Scan Yarn Cone'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Live Machine Status Grid
            const Text('LIVE LOOM OPERATIONAL MATRIX (AIRJET / RAPIER)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 4 : (MediaQuery.of(context).size.width > 650 ? 2 : 1),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _loomStatusCard('AJ-001', 'Airjet', 'RUNNING', 842, 94.2, 'J. Weaver'),
                _loomStatusCard('AJ-002', 'Airjet', 'STOPPED_WARP', 0, 71.0, 'M. Tackler'),
                _loomStatusCard('RP-003', 'Rapier', 'RUNNING', 580, 89.5, 'K. Singh'),
                _loomStatusCard('AJ-004', 'Airjet', 'BREAKDOWN', 0, 45.2, 'S. Engineer'),
                _loomStatusCard('AJ-005', 'Airjet', 'RUNNING', 850, 96.1, 'A. Sharma'),
                _loomStatusCard('RP-006', 'Rapier', 'BEAM_CHANGE', 0, 82.0, 'R. Weaver'),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Alerts Feed
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CRITICAL MILL ALERTS & TELEMETRY TICKER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                  const Divider(height: 20),
                  _alertTile(Icons.error_outline, AppColors.statusDanger, 'Loom AJ-004 breakdown ticket #TCK-401 logged. Motor fault.'),
                  _alertTile(Icons.warning_amber, AppColors.statusWarning, 'Yarn stock 150D Poly (Lot YN-4082) reached reorder level (850 Kg remaining).'),
                  _alertTile(Icons.check_circle_outline, AppColors.statusSuccess, 'Production order PO-9902 (20,000 m) completed successfully.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kpiCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondarySlate)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.secondarySlate)),
        ],
      ),
    );
  }

  Widget _loomStatusCard(String code, String type, String status, int rpm, double eff, String operatorName) {
    Color statusColor = AppColors.statusSuccess;
    if (status == 'STOPPED_WARP' || status == 'BEAM_CHANGE') statusColor = AppColors.statusWarning;
    if (status == 'BREAKDOWN') statusColor = AppColors.statusDanger;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(code, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$rpm RPM', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
              Text('Eff: $eff%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: eff > 90 ? AppColors.statusSuccess : AppColors.statusWarning)),
            ],
          ),
          Text('Operator: $operatorName', style: const TextStyle(fontSize: 11, color: AppColors.secondarySlate)),
        ],
      ),
    );
  }

  Widget _alertTile(IconData icon, Color color, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 13, color: AppColors.textDark))),
        ],
      ),
    );
  }
}
