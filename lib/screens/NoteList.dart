import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_sqflite/DB_Helper.dart';
import 'package:todo_app_sqflite/screens/NoteDetails.dart';

import '../Note.dart';

class NodeList extends StatefulWidget {
  @override
  _NodeListState createState() => _NodeListState();
}

class _NodeListState extends State<NodeList> {

  DB_Helper dbHelper = DB_Helper();
  List<Note> noteList;

  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList == null)
    {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          navigationToDetail(Note("", "", 2), "Add Note");
        },
      ),
    );
  }

  ListView getNoteListView()
  {
    return ListView.builder(
      itemCount: count, 
      itemBuilder: (BuildContext context, int index) { 
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          elevation: 4,
          child: ListTile(
            title: Text(this.noteList[index].title),
            subtitle: Text(this.noteList[index].date),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new),
              onTap: () => navigationToDetail(noteList[index], "Edit To-Do"),
            ),
          ),
        );
      },
    );
  }

  void navigationToDetail(Note note, String title) async
  {

    bool result = await Navigator
      .push(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => NoteDetails(note, title)
      )
    );

    if (result) {
      updateListView();
    }
  }

  void updateListView()
  {
    final Future<Database> dbFuture = this.dbHelper.initializeDatabase();
    dbFuture.then((db) 
    {
      Future<List<Note>> noteListFuture = this.dbHelper.getNoteList();
      noteListFuture.then((noteList)
      {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}