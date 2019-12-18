
import 'package:cashflow/main.dart';
import 'package:cashflow/models/cash.dart';
import 'package:cashflow/pages/riwayat.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/helpers/dbhelper.dart';

class CashForm extends StatefulWidget {
  final Cash cash;
  final ValueChanged<int> changeTab;
  CashForm({Key key, this.cash, this.changeTab}) : super(key: key);

  @override
  CashFormState createState() => CashFormState(this.cash, this.changeTab);
}

class CashFormState extends State<CashForm> {
  Cash cash;
  DbHelper dbHelper = DbHelper();
  // final formKey = GlobalKey<RiwayatState>();

  ValueChanged<int> changeTab;
  DateTime datenow = DateTime.now();
  int _selectedCashType;
  int _selectedCategory;
  List<DropdownMenuItem<int>> listCategory = [];
  List<DropdownMenuItem<int>> cashTypes = [];
  
  CashFormState(this.cash, this.changeTab);

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    if(cash != null) {
      print(cash);
    }
    // TODO: implement initState
    super.initState();
    _selectedCashType = 0;
    _selectedCategory = 0;
    loadCashTypes();
    getListCategory();
    if(riwayatKey.currentState != null) {
      cash = riwayatKey.currentState.getCash;
      editCategory(cash);
    }
  }
  
  void testCategory() {
    listCategory.add(DropdownMenuItem(
      child: Text(
        'hello' 
      ),
      value: 1
    ));
  }
  void getListCategory() async {
    List<Map<String, dynamic>> result = await dbHelper.select('category');
    List<DropdownMenuItem<int>> categoryItem = [];
    categoryItem.add(DropdownMenuItem(
      child: Text(
        'Pilih Kategori'
      ),
      value: 0
    ));
    for(int i=0; i<result.length; i++) {
      categoryItem.add(DropdownMenuItem(
        child: Text(
          result[i]['name'] 
        ),
        value: result[i]['id']
      ));
    }
    setState(() {
      this.listCategory = categoryItem;
    });
  }
  void changeCategory(int value) {
    setState(() {
      _selectedCategory = value;
    });
  }
  void changeCashTypes(int value) {
    setState(() {
      _selectedCashType = value;
    });
  }

  void changeCash(Cash cash) {
    print(cash);
  }

  void loadCashTypes() {
    cashTypes.add(DropdownMenuItem(
      child: new Text('Masuk'),
      value: 0,
    ));
    cashTypes.add(DropdownMenuItem(
      child: new Text('Keluar'),
      value: 1,
    ));
  }

  void editCategory(Cash cash) {
    if(cash != null) {
      nameController.text = cash.name;
      descriptionController.text = cash.description;
      priceController.text = cash.price.toString();
      amountController.text = cash.amount.toString();
      _selectedCashType = cash.type;
      _selectedCategory = cash.categoryId;
    }    
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              Padding( // Nama Form
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              Padding( // Price Form
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              Padding( // Amount Form
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),
              Padding( // Amount Form
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Tipe',
                  ),
                  isExpanded: true,
                  items: cashTypes,
                  hint: Text('Pilih Transaksi'),
                  value: _selectedCashType,
                  onChanged: (value) {
                    changeCashTypes(value);
                  },
                ),
              ),
              Padding( // Category Form
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                  ),                  
                  isExpanded: true,
                  items: listCategory,
                  hint: Text('Pilih Kategori'),
                  value: _selectedCategory,
                  onChanged: (value) {
                    changeCategory(value);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.white,
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Theme.of(context).primaryColor)
                        ),
                        onPressed: () {
                          if(cash == null) {
                            cash = Cash(nameController.text, descriptionController.text, double.parse(priceController.text), double.parse(amountController.text), _selectedCashType, _selectedCategory, datenow, datenow);
                            addCash(cash);
                          } else {
                           cash.name = nameController.text;
                            cash.description = descriptionController.text;
                            cash.price = double.parse(priceController.text);
                            cash.amount = double.parse(amountController.text);
                            cash.type = _selectedCashType;
                            cash.categoryId = _selectedCategory;
                            updateCash(cash);
                          }
                          changeTab(3);
                        },
                      ),
                    ),
                    Container(width: 5.0),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Theme.of(context).primaryColor)
                        ),
                        onPressed: () {
                          changeTab(0);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }

  void addCash(Cash cash) async {
    await dbHelper.insert('cash', cash.toMap());
  }

  void updateCash(Cash cash) async {
    print('edit cash');
    Map<String, dynamic> item = cash.toMap();
    print(item);
    await dbHelper.update('cash', item, item['id']);
  }  
}