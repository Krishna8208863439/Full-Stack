import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  final List<Map<String, dynamic>> _tickets = [
    {'id': 'TCK-401', 'loom': 'AJ-018', 'issue': 'Main Motor Overheat', 'priority': 'HIGH', 'downtime': '00:42:10', 'tech': 'M. Tech', 'status': 'IN_PROGRESS'},
    {'id': 'TCK-402', 'loom': 'RP-004', 'issue': 'Weft Feeder Fault', 'priority': 'CRITICAL', 'downtime': '01:15:30', 'tech': 'S. Engineer', 'status': 'OPEN'},
  ];

  void _showNewTicketDialog() {
    final loomController = TextEditingController(text: 'AJ-004');
    final issueController = TextEditingController(text: 'Warp Stop Sensor Malfunction');
    String priority = 'HIGH';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Machine Breakdown Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: loomController, decoration: const InputDecoration(labelText: 'Machine Code')),
            const SizedBox(height: 10),
            TextField(controller: issueController, decoration: const InputDecoration(labelText: 'Breakdown Issue Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _tickets.insert(0, {
                  'id': 'TCK-${403 + _tickets.length}',
                  'loom': loomController.text,
                  'issue': issueController.text,
                  'priority': priority,
                  'downtime': '00:05:00',
                  'tech': 'Unassigned',
                  'status': 'OPEN',
                });
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
            child: const Text('Dispatch Ticket'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutShell(
      title: 'Machine Maintenance & Breakdown Tickets',
      actions: [
        ElevatedButton.icon(
          onPressed: _showNewTicketDialog,
          icon: const Icon(Icons.build_outlined, size: 18),
          label: const Text('Log Ticket'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceVariantLight),
                      columns: const [
                        DataColumn(label: Text('Ticket ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Loom ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Issue Type', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Priority', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Downtime', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Technician', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _tickets.map((item) {
                        final String status = item['status'];
                        Color statusColor = status == 'RESOLVED' ? AppColors.statusSuccess : (status == 'IN_PROGRESS' ? AppColors.primaryBlue : AppColors.statusDanger);

                        return DataRow(
                          cells: [
                            DataCell(Text(item['id'], style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(item['loom'])),
                            DataCell(Text(item['issue'])),
                            DataCell(Text(item['priority'], style: TextStyle(color: item['priority'] == 'CRITICAL' ? AppColors.statusDanger : AppColors.statusWarning, fontWeight: FontWeight.bold))),
                            DataCell(Text(item['downtime'])),
                            DataCell(Text(item['tech'])),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                              ),
                            ),
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
