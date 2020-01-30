import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_sqflite/DB_Helper.dart';

import '../Note.dart';

class NoteDetails extends StatefulWidget {

  final Note note;
  final String appBarTitle;

  NoteDetails(this.note, this.appBarTitle);

  @override
  _NoteDetailsState createState() => _NoteDetailsState(this.note, this.appBarTitle);
}

class _NoteDetailsState extends State<NoteDetails> {

  static var _priority = ["High", "Low"];
  DB_Helper dbHealper = DB_Helper();

  Note note;
  String appBarTitle;

  TextEditingController titleContoller = TextEditingController();
  TextEditingController discriptionContoller = TextEditingController();

  _NoteDetailsState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText1;
    titleContoller.text = note.title;
    discriptionContoller.text = note.discription;

    return WillPopScope(
      onWillPop: () { 
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: moveToLastScreen,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 5),
                child: ListTile(
                  leading: Icon(Icons.low_priority),
                  title: DropdownButton(
                    items: _priority.map((String dropdownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropdownStringItem,
                        child: Text(dropdownStringItem),
                      );
                    }).toList(), 
                    value: getPriorityAsString(note.priority),
                    onChanged: (String valueSelectedByUser) { 
                      setState(() {
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    },
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 15),
                child: TextField(
                  controller: titleContoller,
                  style: textStyle,
                  onChanged: (value)
                  {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: textStyle,
                    icon: Icon(Icons.title)
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 15),
                child: TextField(
                  controller: discriptionContoller,
                  style: textStyle,
                  onChanged: (value)
                  {
                    updateDiscription();
                  },
                  decoration: InputDecoration(
                    labelText: "Details",
                    labelStyle: textStyle,
                    icon: Icon(Icons.details)
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: Row(
                  children: <Widget>[

                    Expanded(
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        padding: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(
                          "Save",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () 
                        {
                          setState(() {
                            debugPrint("Save btn clicked");
                            _save();
                          });
                        },
                      ),
                    ),

                    Container(width: 5,),

                    Expanded(
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.red,
                        padding: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(
                          "Delete",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () 
                        {
                          setState(() {
                            debugPrint("Delete btn clicked");
                            _delete();
                          });
                        },
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value)
  {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value)
  {
    String priority;

    switch (value) {
      case 1:
        priority = _priority[0];
        break;
      case 2:
        priority = _priority[1];
        break;
    }

    return priority;
  }

  void updateTitle()
  {
    note.title = titleContoller.text;
  }

  void updateDiscription()
  {
    note.discription = discriptionContoller.text;
  }

  void _save() async
  {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await dbHealper.updateNote(note);
    } else {
      result = await dbHealper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog("Status", "Note Saved Successfully");
    } else {
      _showAlertDialog("Status", "Problem Saving Note");
    }
  }

  void _delete() async
  {
    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog("Status", "First add note");
      return;
    }
    
    int result = await dbHealper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog("Status", "Task Deleted");
    } else {
      _showAlertDialog("Status", "Error");
    }
  }

  void _showAlertDialog(String title, String message)
  {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }

  void moveToLastScreen()
  {
    Navigator.pop(context, true);
  }
}