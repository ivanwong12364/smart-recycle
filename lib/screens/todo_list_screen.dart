import 'package:flutter/material.dart';
import '../services/todo_database_service.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _textController = TextEditingController();
  final TodoDatabaseService _db = TodoDatabaseService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final todos = await _db.getTodos();
      setState(() {
        _todos.clear();
        _todos.addAll(todos);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading todos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _addTodo(String title) async {
    if (title.isNotEmpty) {
      try {
        final todo = TodoItem(
          title: title,
          isCompleted: false,
        );
        final id = await _db.insertTodo(todo);
        setState(() {
          _todos.add(TodoItem(
            id: id,
            title: title,
            isCompleted: false,
          ));
        });
        _textController.clear();
      } catch (e) {
        print('Error adding todo: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task')),
        );
      }
    }
  }

  Future<void> _toggleTodo(TodoItem todo) async {
    try {
      todo.isCompleted = !todo.isCompleted;
      await _db.updateTodo(todo);
      setState(() {});
    } catch (e) {
      print('Error updating todo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task')),
      );
    }
  }

  Future<void> _deleteTodo(TodoItem todo) async {
    try {
      await _db.deleteTodo(todo.id!);
      setState(() {
        _todos.remove(todo);
      });
    } catch (e) {
      print('Error deleting todo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycling Tasks'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Add a recycling task...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: _addTodo,
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _addTodo(_textController.text),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (bool? value) => _toggleTodo(todo),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTodo(todo),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class TodoItem {
  final int? id;
  final String title;
  bool isCompleted;

  TodoItem({
    this.id,
    required this.title,
    required this.isCompleted,
  });
} 