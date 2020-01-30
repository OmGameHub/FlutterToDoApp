class Note 
{
  int _id;
  String _title;
  String _discription;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._discription]);

  Note.withId(this._id, this._title, this._date, this._priority, [this._discription]);

  int get id => _id;
  
  String get title => _title;

  String get discription => _discription;

  int get priority => _priority;

  String get date => _date;

  set title(String newTitle)
  {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set discription(String newDiscription)
  {
    if (newDiscription.length <= 255) {
      this._discription = newDiscription;
    }
  }

  set priority(int newPriority)
  {
    if (newPriority <= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate)
  {
    this._date = newDate;
  }

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = this._id;
    }

    map['title'] = this._title;
    map['discription'] = this._discription;
    map['priority'] = this._priority;
    map['date'] = this._date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map)
  {
    this._id = map['id'];
    this._title = map['title'];
    this._discription = map['discription'];
    this._priority = map['priority'];
    this._date = map['date'];
  }

}