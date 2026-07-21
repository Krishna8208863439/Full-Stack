import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/main_layout_shell.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final List<Map<String, dynamic>> _yarnStock = [
    {'code': 'YN-4081', 'spec': '30s Cotton Combed', 'supplier': 'Vardhman Mills', 'cones': 1200, 'gross': 15000.0, 'tare': 800.0, 'net': 14200.0, 'reorder': 5000.0, 'status': 'NORMAL'},
    {'code': 'YN-4082', 'spec': '150D/48F Polyester', 'supplier': 'Reliance Tex', 'cones': 80, 'gross': 900.0, 'tare': 50.0, 'net': 850.0, 'reorder': 2000.0, 'status': 'LOW_STOCK'},
    {'code': 'YN-4083', 'spec': '40s Linen Blend', 'supplier': 'Grasim Industries', 'cones': 450, 'gross': 5700.0, 'tare': 300.0, 'net': 5400.0, 'reorder': 3000.0, 'status': 'NORMAL'},
  ];

  void _showStockInDialog() {
    final codeController = TextEditingController(text: 'YN-4084');
    final specController = TextEditingController(text: '20s Cotton Carded');
    final weightController = TextEditingController(text: '2500');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Record Yarn Stock In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Item Code')),
            const SizedBox(height: 10),
            TextField(controller: specController, decoration: const InputDecoration(labelText: 'Yarn Count / Spec')),
            const SizedBox(height: 10),
            TextField(controller: weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gross Weight (Kg)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final double gross = double.tryParse(weightController.text) ?? 1000.0;
              final double tare = gross * 0.05; // 5% paper cone tare
              setState(() {
                _yarnStock.add({
                  'code': codeController.text,
                  'spec': specController.text,
                  'supplier': 'Vardhman Mills',
                  'cones': 200,
                  'gross': gross,
                  'tare': tare,
                  'net': gross - tare,
                  'reorder': 1500.0,
                  'status': 'NORMAL',
                });
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
            child: const Text('Record Stock In'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutShell(
      title: 'Yarn & Fabric Inventory Management',
      actions: [
        ElevatedButton.icon(
          onPressed: _showStockInDialog,
          icon: const Icon(Icons.add_box_outlined, size: 18),
          label: const Text('Stock In'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search yarn code, supplier, count spec...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Barcode/QR Scanner active. Point camera at yarn cone label.')),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('Scan QR'),
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
                        DataColumn(label: Text('Yarn Code', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Count Spec', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Supplier', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Cones', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Gross Wt (kg)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Tare Wt (kg)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Net Wt (kg)', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _yarnStock.map((item) {
                        final String status = item['status'];
                        final Color statusColor = status == 'LOW_STOCK' ? AppColors.statusWarning : AppColors.statusSuccess;

                        return DataRow(
                          cells: [
                            DataCell(Text(item['code'], style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(item['spec'])),
                            DataCell(Text(item['supplier'])),
                            DataCell(Text('${item['cones']}')),
                            DataCell(Text('${item['gross']}')),
                            DataCell(Text('${item['tare']}')),
                            DataCell(Text('${item['net']}', style: const TextStyle(fontWeight: FontWeight.bold))),
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
