import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';

class ProductionScreen extends ConsumerStatefulWidget {
  const ProductionScreen({super.key});

  @override
  ConsumerState<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends ConsumerState<ProductionScreen> {
  final List<Map<String, dynamic>> _orders = [
    {'no': 'PO-9901', 'customer': 'Apex Textiles', 'quality': '30s-COTTON-63IN', 'target': 50000.0, 'produced': 32400.0, 'status': 'RUNNING'},
    {'no': 'PO-9902', 'customer': 'Raymond Synthetic', 'quality': '150D-POLYESTER', 'target': 20000.0, 'produced': 20000.0, 'status': 'COMPLETED'},
    {'no': 'PO-9903', 'customer': 'Vardhman Mills', 'quality': '40s-COMBED-GREY', 'target': 35000.0, 'produced': 4100.0, 'status': 'SETUP'},
  ];

  void _showNewOrderDialog() {
    final noController = TextEditingController(text: 'PO-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');
    final custController = TextEditingController();
    final qualController = TextEditingController(text: '30s Cotton Combed');
    final targetController = TextEditingController(text: '25000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Production Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: noController, decoration: const InputDecoration(labelText: 'Order Number')),
            const SizedBox(height: 10),
            TextField(controller: custController, decoration: const InputDecoration(labelText: 'Customer Name')),
            const SizedBox(height: 10),
            TextField(controller: qualController, decoration: const InputDecoration(labelText: 'Fabric Quality Spec')),
            const SizedBox(height: 10),
            TextField(controller: targetController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Target Length (Meters)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (custController.text.isNotEmpty) {
                setState(() {
                  _orders.insert(0, {
                    'no': noController.text,
                    'customer': custController.text,
                    'quality': qualController.text,
                    'target': double.tryParse(targetController.text) ?? 10000.0,
                    'produced': 0.0,
                    'status': 'RUNNING',
                  });
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
            child: const Text('Save Order'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutShell(
      title: 'Production Orders & Shift Planning',
      actions: [
        ElevatedButton.icon(
          onPressed: _showNewOrderDialog,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('New Order'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Table Header Controls
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search order number, customer, fabric quality...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Production Orders Data Table
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceVariantLight),
                      columns: const [
                        DataColumn(label: Text('Order No', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Fabric Spec', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Target (m)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Produced (m)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Progress', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _orders.map((item) {
                        final double target = item['target'];
                        final double produced = item['produced'];
                        final double pct = (produced / target).clamp(0.0, 1.0);
                        final String status = item['status'];
                        Color statusColor = status == 'COMPLETED' ? AppColors.statusSuccess : (status == 'RUNNING' ? AppColors.primaryBlue : AppColors.statusWarning);

                        return DataRow(
                          cells: [
                            DataCell(Text(item['no'], style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(item['customer'])),
                            DataCell(Text(item['quality'])),
                            DataCell(Text(target.toStringAsFixed(0))),
                            DataCell(Text(produced.toStringAsFixed(0))),
                            DataCell(
                              SizedBox(
                                width: 100,
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: AppColors.borderLight,
                                  color: statusColor,
                                ),
                              ),
                            ),
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
