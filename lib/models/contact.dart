class Contact {
  int _id;
  String _name;
  String _phone;

  Contact(this._name, this._phone);

  Contact.fromMap(Map<String, dynamic> item) {
    this._id = item['id'];
    this._name = item['name'];
    this._phone = item['phone'];
  }

  int get id => _id;
  String get name => _name;
  String get phone => _phone;

  set name(String value) {
    _name = value;
  }

  set phone(String value) {
    _phone = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> item = Map<String, dynamic>();
    item['id'] = this._id;
    item['name'] = this._name;
    item['phone'] = this._phone;
    return item;
  }
}