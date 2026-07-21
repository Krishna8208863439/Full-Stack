import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/astm_calculator.dart';
import '../../../widgets/main_layout_shell.dart';

class QualityScreen extends ConsumerStatefulWidget {
  const QualityScreen({super.key});

  @override
  ConsumerState<QualityScreen> createState() => _QualityScreenState();
}

class _QualityScreenState extends ConsumerState<QualityScreen> {
  final List<Map<String, dynamic>> _inspections = [
    {'roll': 'ROLL-2026-0491', 'loom': 'AJ-012', 'yards': 120.0, 'width': 63.0, 'points': 6, 'score': 2.85, 'grade': 'GRADE_A'},
    {'roll': 'ROLL-2026-0492', 'loom': 'RP-003', 'yards': 100.0, 'width': 58.0, 'points': 38, 'score': 23.58, 'grade': 'GRADE_B'},
  ];

  void _showNewInspectionDialog() {
    final rollController = TextEditingController(text: 'ROLL-2026-0493');
    final loomController = TextEditingController(text: 'AJ-001');
    final yardsController = TextEditingController(text: '120');
    final widthController = TextEditingController(text: '63');
    final pointsController = TextEditingController(text: '4');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Record ASTM 4-Point Roll Inspection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: rollController, decoration: const InputDecoration(labelText: 'Roll Number')),
            const SizedBox(height: 8),
            TextField(controller: loomController, decoration: const InputDecoration(labelText: 'Loom ID')),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: TextField(controller: yardsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Yards'))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: widthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Width (in)'))),
              ],
            ),
            const SizedBox(height: 8),
            TextField(controller: pointsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Penalty Points')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final double yards = double.tryParse(yardsController.text) ?? 100.0;
              final double width = double.tryParse(widthController.text) ?? 60.0;
              final int points = int.tryParse(pointsController.text) ?? 0;
              final double score = AstmCalculator.calculateScore(totalPenaltyPoints: points, inspectedYards: yards, fabricWidthInches: width);
              final String grade = AstmCalculator.calculateGrade(score);

              setState(() {
                _inspections.insert(0, {
                  'roll': rollController.text,
                  'loom': loomController.text,
                  'yards': yards,
                  'width': width,
                  'points': points,
                  'score': double.parse(score.toStringAsFixed(2)),
                  'grade': grade,
                });
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
            child: const Text('Calculate & Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutShell(
      title: 'Quality Control (ASTM D5430 4-Point System)',
      actions: [
        ElevatedButton.icon(
          onPressed: _showNewInspectionDialog,
          icon: const Icon(Icons.verified_outlined, size: 18),
          label: const Text('Inspect Roll'),
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
                        DataColumn(label: Text('Roll No', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Loom ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Inspected (Yards)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Width (in)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Penalty Points', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Score / 100 sq yd', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Final Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _inspections.map((item) {
                        final String grade = item['grade'];
                        Color gradeColor = grade == 'GRADE_A' ? AppColors.statusSuccess : (grade == 'GRADE_B' ? AppColors.statusWarning : AppColors.statusDanger);

                        return DataRow(
                          cells: [
                            DataCell(Text(item['roll'], style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(item['loom'])),
                            DataCell(Text('${item['yards']}')),
                            DataCell(Text('${item['width']}')),
                            DataCell(Text('${item['points']}')),
                            DataCell(Text('${item['score']}', style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: gradeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: Text(grade, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: gradeColor)),
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
