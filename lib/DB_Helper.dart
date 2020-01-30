import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

import 'Note.dart';

class DB_Helper
{
  static DB_Helper _dbHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDiscription = 'discription';
  String colPriority = 'priority';
  String colDate = 'date';

  DB_Helper._createInstance();

  factory DB_Helper()
  {
    if (_dbHelper == null) {
      _dbHelper = DB_Helper._createInstance();
    }

    return _dbHelper;
  }

  Future<Database> get database async 
  {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async
  {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDB);

    return notesDatabase;
  }

  void _createDB(Database db, int newVersion) async
  {
    await db.execute(
      'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDiscription, TEXT, $colPriority INTEGER, $colDate TEXT)'
    );
  }

  Future<List<Map<String, dynamic>>> getNotesMapList() async
  {
    Database db = await this.database;

    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async
  {
    Database db = await this.database;

    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async
  {
    Database db = await this.database;

    var result = await db.update(
      noteTable, 
      note.toMap(), 
      where: '$colId = ?',
      whereArgs: [note.id]
    );
    return result;
  }

  Future<int> deleteNote(int id) async
  {
    Database db = await this.database;

    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async
  {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    debugPrint("x: $x");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async
  {
    var noteMapList = await getNotesMapList();
    int count = noteMapList.length;

    List<Note> noteList = List();
    for (var i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}