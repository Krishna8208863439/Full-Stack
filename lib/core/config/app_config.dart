/// Enterprise Application Configuration for TexMill ERP
class AppConfig {
  static const String appName = 'TexMill ERP';
  static const String appVersion = '1.0.0';
  static const String companyName = 'TexMill Enterprise Weaving Mills Ltd.';
  
  // Operational Defaults
  static const int defaultTargetRpm = 850;
  static const double defaultReedSpaceCm = 190.0;
  static const int defaultShiftsPerDay = 3;
  
  // Timeout & Sync Settings
  static const int apiTimeoutSeconds = 15;
  static const int offlineSyncIntervalMinutes = 5;
}
