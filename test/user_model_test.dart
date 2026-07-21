import 'package:flutter_test/flutter_test.dart';
import 'package:texmill_erp/core/models/user_model.dart';

void main() {
  group('UserModel Serialization Tests', () {
    test('Deserializes JSON map correctly', () {
      final json = {
        'uid': 'usr_001',
        'email': 'admin@texmill.com',
        'displayName': 'Admin User',
        'roleId': 'admin',
        'department': 'Plant Ops',
        'assignedLoomIds': ['AJ-001', 'AJ-002'],
        'isActive': true,
      };

      final user = UserModel.fromJson(json);

      expect(user.uid, equals('usr_001'));
      expect(user.email, equals('admin@texmill.com'));
      expect(user.displayName, equals('Admin User'));
      expect(user.roleId, equals('admin'));
      expect(user.assignedLoomIds.length, equals(2));
      expect(user.isActive, isTrue);
    });

    test('Serializes to JSON map correctly', () {
      const user = UserModel(
        uid: 'usr_002',
        email: 'weaver@texmill.com',
        displayName: 'Weaver User',
        roleId: 'weaver_operator',
        department: 'Shed A',
      );

      final json = user.toJson();

      expect(json['uid'], equals('usr_002'));
      expect(json['email'], equals('weaver@texmill.com'));
      expect(json['roleId'], equals('weaver_operator'));
    });
  });
}
