import 'package:flutter_test/flutter_test.dart';
import 'package:texmill_erp/core/utils/astm_calculator.dart';

void main() {
  group('ASTM D5430 4-Point System Tests', () {
    test('Calculates score per 100 sq yards accurately', () {
      final score = AstmCalculator.calculateScore(
        totalPenaltyPoints: 6,
        inspectedYards: 120.0,
        fabricWidthInches: 63.0,
      );

      // (6 * 3600) / (120 * 63) = 21600 / 7560 = 2.857...
      expect(score, closeTo(2.857, 0.01));
    });

    test('Classifies Grade A (Fresh) for score <= 20.0', () {
      final grade = AstmCalculator.calculateGrade(2.85);
      expect(grade, equals('GRADE_A'));
    });

    test('Classifies Grade B (Second) for score between 20.1 and 35.0', () {
      final grade = AstmCalculator.calculateGrade(24.5);
      expect(grade, equals('GRADE_B'));
    });

    test('Classifies Grade C (Cut Piece / Reject) for score > 35.0', () {
      final grade = AstmCalculator.calculateGrade(42.0);
      expect(grade, equals('GRADE_C'));
    });
  });
}
