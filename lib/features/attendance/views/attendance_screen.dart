import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  final List<Map<String, dynamic>> _staff = [
    {'empId': 'EMP-101', 'name': 'John Weaver', 'role': 'Loom Weaver', 'shift': 'SHIFT_A', 'looms': 'AJ-001 to 004', 'status': 'PRESENT', 'meters': 420.0},
    {'empId': 'EMP-102', 'name': 'Rajesh Tackler', 'role': 'Master Tackler', 'shift': 'SHIFT_A', 'looms': 'Shed A All', 'status': 'PRESENT', 'meters': 0.0},
    {'empId': 'EMP-103', 'name': 'Amit Kumar', 'role': 'Loom Weaver', 'shift': 'SHIFT_A', 'looms': 'AJ-005 to 008', 'status': 'ABSENT', 'meters': 0.0},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutShell(
      title: 'Workforce Attendance & Shift Roster',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Daily Shift Roster Matrix • Shift A (06:00 - 14:00)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance Log Synchronized with Payroll.')));
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Mark Shift Attendance'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceVariantLight),
                      columns: const [
                        DataColumn(label: Text('Emp ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Employee Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Shift', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Assigned Looms', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Piece-Rate Output (m)', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _staff.map((item) {
                        final String status = item['status'];
                        Color statusColor = status == 'PRESENT' ? AppColors.statusSuccess : AppColors.statusDanger;

                        return DataRow(
                          cells: [
                            DataCell(Text(item['empId'], style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(item['name'])),
                            DataCell(Text(item['role'])),
                            DataCell(Text(item['shift'])),
                            DataCell(Text(item['looms'])),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                              ),
                            ),
                            DataCell(Text('${item['meters']} m', style: const TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
