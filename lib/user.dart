
class User{
  String _email;
  String _name;
  String _username;

  User(this._email, this._name, this._username);

  User.map(dynamic obj) {
    this._email = obj['email'];
    this._name = obj['name'];
    this._username = obj['username'];
  }

  String get email => _email;
  String get name => _name;
  String get username => _username;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['email'] = _email;
    map['name'] = _name;
    map['username'] = _username;

    return map;
  }

  /// fromMap deserialize's the data we receive from Firestore
  /// then initializes a new User Object with the data.
  User.fromMap(Map<String, dynamic> map) {
    this._email = map['email'];
    this._name = map['name'];
    this._username = map['username'];
  }

}