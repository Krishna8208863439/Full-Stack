import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _selectedReport = 'DAILY_PRODUCTION';

  void _exportReport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating $_selectedReport Report in $format format... Download starting.')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutShell(
      title: 'Enterprise Reports & Data Export',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Controls Card
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
                  const Text('Select Report Type & Export Parameters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedReport,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'DAILY_PRODUCTION', child: Text('Daily Weaving Production Summary')),
                            DropdownMenuItem(value: 'YARN_RECONCILIATION', child: Text('Yarn Warehouse Stock Reconciliation')),
                            DropdownMenuItem(value: 'LOOM_OEE', child: Text('Loom Telemetry & OEE Efficiency Report')),
                            DropdownMenuItem(value: 'ASTM_QUALITY', child: Text('ASTM 4-Point Quality Defect Pareto')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedReport = v);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => _exportReport('PDF'),
                        icon: const Icon(Icons.picture_as_pdf, size: 18),
                        label: const Text('Export PDF'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusDanger, foregroundColor: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _exportReport('Excel (.xlsx)'),
                        icon: const Icon(Icons.table_chart, size: 18),
                        label: const Text('Export Excel'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusSuccess, foregroundColor: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _exportReport('CSV'),
                        icon: const Icon(Icons.file_download_outlined, size: 18),
                        label: const Text('CSV'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Report Canvas Preview
            const Text('REPORT PREVIEW CANVAS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondarySlate)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TexMill Enterprise - $_selectedReport Ledger', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    const Text('Generated on 2026-07-21 10:15:00 IST • Plant Operations', style: TextStyle(fontSize: 12, color: AppColors.secondarySlate)),
                    const Divider(height: 24),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          'Report Preview Ledger Data:\n\n'
                          'Loom AJ-001 | Order: PO-9901 | Produced: 420m | Target: 450m | Efficiency: 94.2% | Grade A: 100%\n'
                          'Loom AJ-002 | Order: PO-9901 | Produced: 210m | Target: 450m | Efficiency: 71.0% | Grade A: 85%\n'
                          'Loom RP-003 | Order: PO-9903 | Produced: 390m | Target: 400m | Efficiency: 89.5% | Grade B: 15%\n'
                          'Loom AJ-005 | Order: PO-9901 | Produced: 460m | Target: 450m | Efficiency: 96.1% | Grade A: 100%\n',
                          style: TextStyle(fontFamily: 'monospace', fontSize: 13),
                        ),
                      ),
                    ),
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
