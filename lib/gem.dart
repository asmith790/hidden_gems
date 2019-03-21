class Gem {
  String _id;
  String _name;
  String _description;
  //var _tags = [];
  List <String> _tags;
  String _gps;
  String _userid;
  String _picture;
  bool _finished;
  int _rating;

  Gem(this._id, this._name, this._description, this._tags, this._gps, this._userid, this._picture, this._finished, this._rating);

  Gem.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._description = obj['description'];
    this._tags = obj['tags'];
    this._gps = obj['gps'];
    this._userid = obj['userid'];
    this._picture = obj['picture'];
    this._finished = obj['finished'];
    this._rating = obj['rating'];
  }

  String get id => _id;
  String get name => _name;
  String get description => _description;
  List <String> get tags => _tags;
  String get gps => _gps;
  String get userid => _userid;
  String get picture => _picture;
  bool get finished => _finished;
  int get rating => _rating;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['description'] = _description;
    map['tags'] = _tags;
    map['gps'] = _gps;
    map['userid'] = _userid;
    map['picture'] = _picture;
    map['finished'] = _finished;
    map['rating'] = _rating;

    return map;
  }

  Gem.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._tags = map['tags'];
    this._gps = map['gps'];
    this._userid = map['userid'];
    this._picture = map['picture'];
    this._finished = map['finished'];
    this._rating = map['rating'];
  }
}