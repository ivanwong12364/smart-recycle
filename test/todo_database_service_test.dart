import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_recycle/services/todo_database_service.dart';
import 'package:flutter_smart_recycle/screens/todo_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late TodoDatabaseService todoDatabaseService;

  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Set factory
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Create a new database service instance for each test
    todoDatabaseService = TodoDatabaseService();
    
    // Clean up the database before each test
    final db = await todoDatabaseService.database;
    await db.delete('todos');
  });

  tearDown(() async {
    // Close the database after each test
    await todoDatabaseService.close();
  });

  group('TodoDatabaseService Tests', () {
    test('insertTodo should add a new todo item', () async {
      // Arrange
      final todo = TodoItem(
        title: 'Test Todo',
        isCompleted: false,
      );

      // Act
      final id = await todoDatabaseService.insertTodo(todo);
      final todos = await todoDatabaseService.getTodos();

      // Assert
      expect(todos.length, equals(1));
      expect(todos.first.id, equals(id));
      expect(todos.first.title, equals('Test Todo'));
      expect(todos.first.isCompleted, equals(false));
    });

    test('getTodos should return empty list when no todos exist', () async {
      // Act
      final todos = await todoDatabaseService.getTodos();

      // Assert
      expect(todos, isEmpty);
    });

    test('updateTodo should modify existing todo', () async {
      // Arrange
      final todo = TodoItem(
        title: 'Original Todo',
        isCompleted: false,
      );
      final id = await todoDatabaseService.insertTodo(todo);

      // Create updated todo
      final updatedTodo = TodoItem(
        id: id,
        title: 'Updated Todo',
        isCompleted: true,
      );

      // Act
      await todoDatabaseService.updateTodo(updatedTodo);
      final todos = await todoDatabaseService.getTodos();

      // Assert
      expect(todos.length, equals(1));
      expect(todos.first.id, equals(id));
      expect(todos.first.title, equals('Updated Todo'));
      expect(todos.first.isCompleted, equals(true));
    });

    test('deleteTodo should remove todo item', () async {
      // Arrange
      final todo = TodoItem(
        title: 'Todo to Delete',
        isCompleted: false,
      );
      final id = await todoDatabaseService.insertTodo(todo);

      // Act
      await todoDatabaseService.deleteTodo(id);
      final todos = await todoDatabaseService.getTodos();

      // Assert
      expect(todos, isEmpty);
    });

    test('multiple todos should be handled correctly', () async {
      // Arrange
      final todos = [
        TodoItem(title: 'First Todo', isCompleted: false),
        TodoItem(title: 'Second Todo', isCompleted: true),
        TodoItem(title: 'Third Todo', isCompleted: false),
      ];

      // Act
      for (var todo in todos) {
        await todoDatabaseService.insertTodo(todo);
      }
      final savedTodos = await todoDatabaseService.getTodos();

      // Assert
      expect(savedTodos.length, equals(3));
      expect(savedTodos[0].title, equals('First Todo'));
      expect(savedTodos[0].isCompleted, equals(false));
      expect(savedTodos[1].title, equals('Second Todo'));
      expect(savedTodos[1].isCompleted, equals(true));
      expect(savedTodos[2].title, equals('Third Todo'));
      expect(savedTodos[2].isCompleted, equals(false));
    });
  });
} 