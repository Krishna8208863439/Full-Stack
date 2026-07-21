/// Global Constants for TexMill Weaving ERP
class AppConstants {
  // Roles
  static const String roleAdmin = 'admin';
  static const String rolePlantManager = 'plant_manager';
  static const String roleSupervisor = 'supervisor';
  static const String roleInspector = 'quality_inspector';
  static const String roleTechnician = 'maintenance_tech';
  static const String roleWeaver = 'weaver_operator';

  // Loom Types
  static const String loomAirjet = 'Airjet';
  static const String loomRapier = 'Rapier';
  static const String loomWaterjet = 'Waterjet';
  static const String loomShuttle = 'Shuttle';

  // Machine Operational Statuses
  static const String machineRunning = 'RUNNING';
  static const String machineStoppedWarp = 'STOPPED_WARP';
  static const String machineStoppedWeft = 'STOPPED_WEFT';
  static const String machineBeamChange = 'BEAM_CHANGE';
  static const String machineBreakdown = 'BREAKDOWN';
  static const String machineMaintenance = 'MAINTENANCE';

  // Fabric Quality Grades
  static const String gradeFresh = 'GRADE_A';
  static const String gradeSecond = 'GRADE_B';
  static const String gradeCutPiece = 'GRADE_C';
  static const String gradeScrap = 'REJECTED';
}
