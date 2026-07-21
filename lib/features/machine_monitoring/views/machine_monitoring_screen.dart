import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';

class MachineMonitoringScreen extends ConsumerWidget {
  const MachineMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final looms = [
      {'code': 'AJ-001', 'type': 'Airjet', 'rpm': 842, 'eff': 94.2, 'stops': 'W:2 WF:0', 'weaver': 'J. Smith', 'status': 'RUNNING'},
      {'code': 'AJ-002', 'type': 'Airjet', 'rpm': 0, 'eff': 71.0, 'stops': 'W:14 WF:3', 'weaver': 'M. Tackler', 'status': 'STOPPED_WARP'},
      {'code': 'RP-003', 'type': 'Rapier', 'rpm': 580, 'eff': 89.5, 'stops': 'W:1 WF:1', 'weaver': 'K. Singh', 'status': 'RUNNING'},
      {'code': 'AJ-004', 'type': 'Airjet', 'rpm': 0, 'eff': 45.2, 'stops': 'W:0 WF:0', 'weaver': 'S. Tech', 'status': 'BREAKDOWN'},
      {'code': 'AJ-005', 'type': 'Airjet', 'rpm': 850, 'eff': 96.1, 'stops': 'W:0 WF:1', 'weaver': 'A. Sharma', 'status': 'RUNNING'},
      {'code': 'RP-006', 'type': 'Rapier', 'rpm': 0, 'eff': 82.0, 'stops': 'W:0 WF:0', 'weaver': 'R. Weaver', 'status': 'BEAM_CHANGE'},
    ];

    return MainLayoutShell(
      title: 'Real-Time Machine Monitoring',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search loom code or operator...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: 'ALL',
                  items: const [
                    DropdownMenuItem(value: 'ALL', child: Text('All Sheds')),
                    DropdownMenuItem(value: 'SHED_A', child: Text('Shed A')),
                    DropdownMenuItem(value: 'SHED_B', child: Text('Shed B')),
                  ],
                  onChanged: (v) {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 950 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.5,
                ),
                itemCount: looms.length,
                itemBuilder: (context, index) {
                  final item = looms[index];
                  final status = item['status'] as String;
                  Color statusColor = AppColors.statusSuccess;
                  if (status.contains('STOPPED') || status == 'BEAM_CHANGE') statusColor = AppColors.statusWarning;
                  if (status == 'BREAKDOWN') statusColor = AppColors.statusDanger;

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
                            Text('${item['code']} [${item['type']}]', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['rpm']} RPM', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                            Text('Efficiency: ${item['eff']}%', style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)),
                          ],
                        ),
                        Text('Stop Counters: ${item['stops']}', style: const TextStyle(fontSize: 12, color: AppColors.secondarySlate)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Operator: ${item['weaver']}', style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                            OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Machine Telemetry - ${item['code']}'),
                                    content: Text('Target RPM: 850\nCurrent RPM: ${item['rpm']}\nPicks Today: 1,482,000\nAssigned Weaver: ${item['weaver']}'),
                                    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
                              child: const Text('Telemetry', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
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
}
