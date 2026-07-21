import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../authentication/providers/auth_provider.dart';

class WorkerDashboardScreen extends ConsumerStatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  ConsumerState<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends ConsumerState<WorkerDashboardScreen> {
  double _todayLoggedMeters = 380.0;
  bool _shiftAttendanceMarked = true;

  final List<Map<String, dynamic>> _tasks = [
    {'task': 'Inspect Airjet Loom AJ-001 Warp Thread Tension', 'status': 'IN_PROGRESS', 'priority': 'HIGH'},
    {'task': 'Clear Weft Stop Sensor on Loom AJ-002', 'status': 'PENDING', 'priority': 'NORMAL'},
    {'task': 'Log End-of-Shift Woven Meterage Entry', 'status': 'PENDING', 'priority': 'HIGH'},
  ];

  void _showLogProductionDialog() {
    final meterController = TextEditingController(text: '40');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Worker Production Output'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter newly woven meters for assigned Loom AJ-001:', style: TextStyle(fontSize: 13, color: AppColors.secondarySlate)),
            const SizedBox(height: 12),
            TextField(
              controller: meterController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Woven Meters', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final double added = double.tryParse(meterController.text) ?? 0.0;
              setState(() {
                _todayLoggedMeters += added;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Production output logged! Total today: ${_todayLoggedMeters.toStringAsFixed(0)} m')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
            child: const Text('Submit Output Log'),
          ),
        ],
      ),
    );
  }

  void _showLeaveRequestDialog() {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Leave Request to Admin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Reason for Leave Request', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave request submitted to Plant Operations Manager.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('WORKER DASHBOARD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.statusSuccess.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
              child: const Text('ROLE: WORKER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.statusSuccess)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.statusDanger),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primaryBlue,
                    child: Icon(Icons.engineering, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome, ${user?.displayName ?? "John Weaver"}!', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        Text('Shift A Operator • ${user?.department ?? "Shed A Weaving Floor"}', style: const TextStyle(fontSize: 12, color: AppColors.secondarySlate)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _shiftAttendanceMarked = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Shift A Attendance Marked: PRESENT')),
                      );
                    },
                    icon: Icon(_shiftAttendanceMarked ? Icons.check_circle : Icons.how_to_reg, size: 18),
                    label: Text(_shiftAttendanceMarked ? 'PRESENT (SHIFT A)' : 'MARK ATTENDANCE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _shiftAttendanceMarked ? AppColors.statusSuccess : AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Worker Assigned Machine Card
            const Text('YOUR ASSIGNED LOOM TELEMETRY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondarySlate)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.precision_manufacturing, color: AppColors.primaryBlue, size: 24),
                          SizedBox(width: 10),
                          Text('LOOM AJ-001 [AIRJET]', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.statusSuccess.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                        child: const Text('RUNNING', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.statusSuccess)),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _workerMetricTile('SPEED RPM', '842 RPM', AppColors.primaryBlue),
                      _workerMetricTile('EFFICIENCY', '94.2%', AppColors.statusSuccess),
                      _workerMetricTile('STOP COUNTS', 'Warp: 2 | Weft: 0', AppColors.statusWarning),
                      _workerMetricTile('LOGGED TODAY', '${_todayLoggedMeters.toStringAsFixed(0)} m', AppColors.textDark),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showLogProductionDialog,
                          icon: const Icon(Icons.add_chart, size: 18),
                          label: const Text('Log Woven Meters Output'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _showLeaveRequestDialog,
                        icon: const Icon(Icons.event_note, size: 18),
                        label: const Text('Request Leave'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Today's Assigned Tasks List
            const Text('TODAY SHIFT TASKS & INSTRUCTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondarySlate)),
            const SizedBox(height: 8),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tasks.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  final isDone = task['status'] == 'DONE';

                  return ListTile(
                    leading: Checkbox(
                      value: isDone,
                      activeColor: AppColors.statusSuccess,
                      onChanged: (val) {
                        setState(() {
                          _tasks[index]['status'] = (val ?? false) ? 'DONE' : 'PENDING';
                        });
                      },
                    ),
                    title: Text(
                      task['task'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                        color: isDone ? AppColors.secondarySlate : AppColors.textDark,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.statusSuccess.withOpacity(0.1) : AppColors.statusWarning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task['status'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isDone ? AppColors.statusSuccess : AppColors.statusWarning,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _workerMetricTile(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondarySlate)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}
