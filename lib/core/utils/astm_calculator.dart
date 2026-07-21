/// ASTM D5430 4-Point System Fabric Inspection Grade Calculator
class AstmCalculator {
  /// Calculate penalty points score per 100 square yards
  /// Formula: (Total Penalty Points * 3600) / (Inspected Yards * Width Inches)
  static double calculateScore({
    required int totalPenaltyPoints,
    required double inspectedYards,
    required double fabricWidthInches,
  }) {
    if (inspectedYards <= 0 || fabricWidthInches <= 0) return 0.0;
    return (totalPenaltyPoints * 3600.0) / (inspectedYards * fabricWidthInches);
  }

  /// Auto-classify fabric grade based on score
  static String calculateGrade(double scorePer100SqYds) {
    if (scorePer100SqYds <= 20.0) {
      return 'GRADE_A'; // Fresh Fabric
    } else if (scorePer100SqYds <= 35.0) {
      return 'GRADE_B'; // Second Quality
    } else {
      return 'GRADE_C'; // Cut Piece / Reject
    }
  }
}
