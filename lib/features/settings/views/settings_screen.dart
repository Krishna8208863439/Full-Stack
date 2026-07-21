import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutShell(
      title: 'Mill Settings & Audit Trail',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mill Parameters Form Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mill Operational Master Configuration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: '190.0',
                            decoration: const InputDecoration(labelText: 'Default Reed Space (cm)', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: '850',
                            decoration: const InputDecoration(labelText: 'Default Airjet Loom Target RPM', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: '06:00 - 14:00',
                            decoration: const InputDecoration(labelText: 'Shift A Timings', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: '14:00 - 22:00',
                            decoration: const InputDecoration(labelText: 'Shift B Timings', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: '22:00 - 06:00',
                            decoration: const InputDecoration(labelText: 'Shift C Timings', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Factory master configuration updated.')));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
                      child: const Text('Save Master Settings'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Immutable Audit Logs Table
            const Text('SYSTEM AUDIT TRAIL LOGS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Card(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.surfaceVariantLight),
                  columns: const [
                    DataColumn(label: Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('User', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Details', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('2026-07-21 10:14:02')),
                      DataCell(Text('admin@texmill-erp.com')),
                      DataCell(Text('ADMIN')),
                      DataCell(Text('UPDATE_ORDER')),
                      DataCell(Text('Updated PO-9901 target meters to 50,000')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('2026-07-21 09:30:15')),
                      DataCell(Text('inspector02@texmill-erp.com')),
                      DataCell(Text('QUALITY')),
                      DataCell(Text('SUBMIT_QA')),
                      DataCell(Text('Inspected ROLL-2026-0491. Final Grade: GRADE_A')),
                    ]),
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
