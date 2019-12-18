
import 'package:cashflow/models/cash.dart';
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
  ValueChanged<int> changeTab;
  CashFormState(this.cash, this.changeTab);
  DateTime datenow = DateTime.now();
  int _selectedCashType;
  List<DropdownMenuItem<int>> cashTypes = [];
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    _selectedCashType = 0;
    loadCashTypes();
    super.initState();
  }

  void changeCashTypes(int value) {
    setState(() {
      _selectedCashType = value;
    });
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

  @override
  Widget build(BuildContext context) {
    if(cash != null) {
      nameController.text = cash.name;
      descriptionController.text = cash.description;
    }
    return Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
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
                  labelText: 'harga',
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
                  labelText: 'jumlah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              ),
            ),
            Padding( // Amount Form
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: DropdownButton(
                items: cashTypes,
                hint: Text('Pilih Transaksi'),
                value: _selectedCashType,
                onChanged: (value) {
                  changeCashTypes(value);
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
                          cash = Cash(nameController.text, descriptionController.text, double.parse(priceController.text), double.parse(amountController.text), _selectedCashType, 1, datenow, datenow);
                        }
                        addCash(cash);
                        // if(cash == null) {
                        //   cash = Cash(nameController.text, descriptionController.text, double.parse(priceController.text), double.parse(amountController.text), true, 1, datenow, datenow);
                        // } else {
                        //   cash.name = nameController.text;
                        //   cash.description = descriptionController.text;
                        //   cash.price = double.parse(priceController.text);
                        //   cash.amount = double.parse(amountController.text);
                        //   cash.type = true;
                        //   cash.categoryId = 1;
                        // }
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
      );
  }

  void addCash(Cash cash) async {
    await dbHelper.insert('cash', cash.toMap());
  }

}