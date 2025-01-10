import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_smart_recycle/services/auth_service.dart';
import 'package:flutter_smart_recycle/services/database_service.dart';

// Generate mock classes
@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<DatabaseService>(),
  MockSpec<UserCredential>(),
  MockSpec<User>(),
])
import 'auth_service_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockDatabaseService mockDatabaseService;
  late AuthService authService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockDatabaseService = MockDatabaseService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    
    // Setup the auth service with mocks
    authService = AuthService(
      auth: mockFirebaseAuth,
      firestore: mockFirestore,
      db: mockDatabaseService,
    );

    // Setup common mock behaviors
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');
  });

  group('AuthService Tests', () {
    test('signOut should complete successfully', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
      when(mockDatabaseService.clearUserAuth()).thenAnswer((_) async => {});

      // Act & Assert
      await expectLater(authService.signOut(), completes);
      verify(mockFirebaseAuth.signOut()).called(1);
      verify(mockDatabaseService.clearUserAuth()).called(1);
    });

    test('signIn should complete successfully with valid credentials', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';
      
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);
      
      when(mockDatabaseService.saveUserAuth(any)).thenAnswer((_) async => {});

      // Act
      await authService.signIn(email, password);

      // Assert
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
      verify(mockDatabaseService.saveUserAuth(any)).called(1);
    });
  });
} 