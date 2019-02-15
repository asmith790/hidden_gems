class Gem {
  String _id;
  String _name;
  String _description;
  //bool finished;
  //String gps;
  //int rating;
  String _tags;

  Gem(this._id, this._name, this._description, this._tags);

  Gem.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._description = obj['description'];
    this._tags = obj['tags'];
  }

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get tags => _tags;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['description'] = _description;
    map['tags'] = _tags;

    return map;
  }

  Gem.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._tags = map['tags'];
  }
}