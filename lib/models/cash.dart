class Cash {
  int _id;
  String _name;
  String _description;
  double _price;
  double _amount;
  int _type;
  int _categoryId;
  DateTime _createdAt;
  DateTime _updatedAt;
  

  Cash(this._name, this._description, this._price, this._amount, this._type, this._categoryId, this._createdAt, this._updatedAt);

  Cash.fromMap(Map<String, dynamic> item) {
    this._id = item['id'];
    this._name = item['name'];
    this._description = item['description'];
    this._amount = item['amount'];
    this._price = item['price'];
    this._type = item['type'];
    this._categoryId = item['categoryId'];
    // this._createdAt = item['createdAt'];
    // this._updatedAt = item['updatedAt'];
  }

  int get id => _id;
  String get name => _name;
  String get description => _description;
  double get amount => _amount;
  double get price => _price;
  int get type => _type;
  int get categoryId => _categoryId;

  set name(String value) {
    _name = value;
  }

  set description(String value) {
    _description = value;
  }

  set amount(double value) {
    _amount = value;
  }

  set price(double value) {
    _price = value;
  }

  set type(int value) {
    _type = value;
  }
  
  set categoryId(int value) {
    _categoryId = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> item = Map<String, dynamic>();
    item['id'] = this._id;
    item['name'] = this._name;
    item['description'] = this._description;
    item['price'] = this._price;
    item['amount'] = this._amount;
    item['type'] = this._type;
    item['categoryId'] = this._categoryId;
    // item['createdAt'] = this._createdAt;
    // item['updatedAt'] = this._updatedAt;    
    return item;
  }
}