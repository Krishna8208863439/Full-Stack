import 'package:flutter/foundation.dart';

@immutable
class MachineModel {
  final String machineId;
  final String code;
  final String type;
  final String shedId;
  final String status;
  final int targetRpm;
  final int currentRpm;
  final double efficiency;
  final String currentOrderId;
  final int warpStops;
  final int weftStops;
  final int totalPicks;
  final String assignedWeaver;
  final String assignedTackler;

  const MachineModel({
    required this.machineId,
    required this.code,
    required this.type,
    required this.shedId,
    required this.status,
    required this.targetRpm,
    required this.currentRpm,
    required this.efficiency,
    required this.currentOrderId,
    required this.warpStops,
    required this.weftStops,
    required this.totalPicks,
    required this.assignedWeaver,
    required this.assignedTackler,
  });

  factory MachineModel.fromJson(Map<String, dynamic> json) {
    return MachineModel(
      machineId: json['machineId'] as String,
      code: json['code'] as String,
      type: json['type'] as String? ?? 'Airjet',
      shedId: json['shedId'] as String? ?? 'SHED_A',
      status: json['status'] as String? ?? 'RUNNING',
      targetRpm: json['targetRpm'] as int? ?? 850,
      currentRpm: json['currentRpm'] as int? ?? 842,
      efficiency: (json['efficiency'] as num?)?.toDouble() ?? 92.0,
      currentOrderId: json['currentOrderId'] as String? ?? 'PO-9901',
      warpStops: json['warpStops'] as int? ?? 0,
      weftStops: json['weftStops'] as int? ?? 0,
      totalPicks: json['totalPicks'] as int? ?? 1000000,
      assignedWeaver: json['assignedWeaver'] as String? ?? 'Unassigned',
      assignedTackler: json['assignedTackler'] as String? ?? 'Unassigned',
    );
  }
}
