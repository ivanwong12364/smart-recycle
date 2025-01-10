import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_smart_recycle/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

@GenerateNiceMocks([MockSpec<User>()])
import 'database_service_test.mocks.dart';

void main() {
  late DatabaseService databaseService;
  late MockUser mockUser;

  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Set factory
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Create a new database service instance for each test
    databaseService = DatabaseService();
    
    // Create mock user
    mockUser = MockUser();
    when(mockUser.uid).thenReturn('test-uid');
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.displayName).thenReturn('Test User');
  });

  tearDown(() async {
    // Close the database after each test
    await databaseService.close();
  });

  group('DatabaseService Tests', () {
    test('saveUserAuth should store user data correctly', () async {
      // Act
      await databaseService.saveUserAuth(mockUser);

      // Assert
      final savedUser = await databaseService.getLastUser();
      expect(savedUser, isNotNull);
      expect(savedUser!['uid'], equals('test-uid'));
      expect(savedUser['email'], equals('test@example.com'));
      expect(savedUser['displayName'], equals('Test User'));
    });

    test('clearUserAuth should remove all user data', () async {
      // Arrange
      await databaseService.saveUserAuth(mockUser);

      // Act
      await databaseService.clearUserAuth();

      // Assert
      final savedUser = await databaseService.getLastUser();
      expect(savedUser, isNull);
    });

    test('getLastUser should return null when no user exists', () async {
      // Act
      final result = await databaseService.getLastUser();

      // Assert
      expect(result, isNull);
    });

    test('saveUserAuth should update existing user data', () async {
      // Arrange
      await databaseService.saveUserAuth(mockUser);
      
      // Create a new mock user with different data
      final newMockUser = MockUser();
      when(newMockUser.uid).thenReturn('new-test-uid');
      when(newMockUser.email).thenReturn('new-test@example.com');
      when(newMockUser.displayName).thenReturn('New Test User');

      // Act
      await databaseService.saveUserAuth(newMockUser);

      // Assert
      final savedUser = await databaseService.getLastUser();
      expect(savedUser, isNotNull);
      expect(savedUser!['uid'], equals('new-test-uid'));
      expect(savedUser['email'], equals('new-test@example.com'));
      expect(savedUser['displayName'], equals('New Test User'));
    });
  });
} 