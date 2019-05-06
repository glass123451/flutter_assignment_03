import 'package:flutter/material.dart';
import 'package:assignment03/ui/todo.dart';
import 'package:assignment03/ui/addTodo.dart';
void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => TodoPage(),
        '/addTodo': (BuildContext context) => AddTodoPage(),
      },
    );
  }
}