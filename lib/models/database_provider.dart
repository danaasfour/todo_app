import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoa_app/models/task.dart';
import 'package:todoa_app/models/user.dart';

class DatabaseProvider with ChangeNotifier {
  late Database _database;
  late User user;
  List<Task> tasks = [];

  _openDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE User (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT UNIQUE, password TEXT)');
      await db.execute(
          'CREATE TABLE Task (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date TEXT,time TEXT, description TEXT, status TEXT, user_id INTEGER)');
    });
  }

  Future<Map<String, dynamic>> signUp(
      String name, String email, String password) async {
    await _openDB();
    var count = Sqflite.firstIntValue(await _database
        .rawQuery('SELECT COUNT(*) from User WHERE email = ? ', [email]));
    if (count == 0) {
      await _database.rawInsert(
          'INSERT INTO User(name, email, password) VALUES(?,?,?)',
          [name, email, password]);
      List<Map> user = await _database.query('User',
          columns: ['id', 'email', 'password', 'name'],
          where: "email = ? and password = ?",
          whereArgs: [email, password]);
      _saveUserData(user.first);
      return {'result': true};
    }
    return {'result': false, 'msg': 'Email is already exist'};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    await _openDB();
    List<Map> user = await _database.query('User',
        columns: ['id', 'email', 'password', 'name'],
        where: "email = ? and password = ?",
        whereArgs: [email, password]);

    if (user.isNotEmpty) {
      _saveUserData(user.first);
      return {'result': true};
    } else {
      return {'result': false, 'msg': 'Email or password is wrong!'};
    }
  }

  _saveUserData(Map user) {
    this.user = User(
        id: user['id'],
        name: user['name'],
        email: user['email'],
        password: user['password']);
  }

  addNewTask(
      {required String title,
      required String date,
      required String time,
      required String description}) async {
    await _openDB();
    await _database.rawInsert(
        'INSERT INTO Task(title, date, time, description, status, user_id) VALUES(?,?,?,?,?,?)',
        [title, date, time, description, Status.inProgress.name, user.id]);
    getAllTasks();
  }

  getAllTasks() async {
    tasks = [];
    final list = await _database
        .rawQuery('SELECT * FROM Task WHERE user_id = ${user.id}');
    for (Map value in list) {
      tasks.add(Task(
          id: value['id'],
          userId: user.id,
          title: value['title'],
          date: value['date'],
          time: value['time'],
          status: value['status'],
          description: value['description']));
    }
    notifyListeners();
  }

  updateTask(Task task) async {
    tasks[tasks.indexWhere((element) =>
        element.id == task.id && element.userId == task.userId)] = task;
    await _openDB();
    Map<String, dynamic> row = {
      'title': task.title,
      'date': task.date,
      'time': task.time,
      'status': task.status,
      'description': task.description,
    };
    await _database.update('Task', row, where: 'id = ?', whereArgs: [task.id]);
    notifyListeners();
  }

  deleteTask(int id) async {
    tasks.removeWhere(
        (element) => element.id == id && element.userId == user.id);
    await _openDB();
    await _database.delete('Task', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }
}
