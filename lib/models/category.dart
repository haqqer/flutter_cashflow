class Category {
  int _id;
  String _name;

  Category(this._name);

  Category.fromMap(Map<String, dynamic> item) {
    this._id = item['id'];
    this._name = item['name'];
  }

  int get id => _id;
  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> item = Map<String, dynamic>();
    item['id'] = this._id;
    item['name'] = this._name;
    return item;
  }
}