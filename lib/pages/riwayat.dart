import 'package:flutter/material.dart';
import 'package:cashflow/models/cash.dart';
import 'package:cashflow/helpers/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class Riwayat extends StatefulWidget {
  Riwayat({ Key key }) : super(key: key);
  @override
  RiwayatState createState() => RiwayatState();
}

class RiwayatState extends State<Riwayat> with SingleTickerProviderStateMixin{
  DbHelper dbHelper = DbHelper();
  int count = 0;
  Cash cash;
  List<Cash> cashList;
  int filter = 3;


  TabController tabController;

  void handleTabSelection() {
    setState(() {
      filter = tabController.index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    // tabController = TabController(vsync: this, length: 3);
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(handleTabSelection);
    print(filter);
    updateListView(filter);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              controller: tabController,
              indicatorColor: Theme.of(context).primaryColorDark,
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (value) {
                setState(() {
                  updateListView(value);
                });
              },
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Semua',
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                )              
              ],
            ),
          )
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            allTransaction(textStyle),
            allTransaction(textStyle),
            allTransaction(textStyle),
          ],
        )
      );
  }
  Widget allTransaction(TextStyle textStyle) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                this.cashList[index].type == 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: this.cashList[index].type == 0 ? Colors.green : Colors.red,
                size: 40,
              ),
            ),
            title: Text(this.cashList[index].name, style: textStyle),
            subtitle: Text('Rp ${this.cashList[index].price.toString()}'),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                deleteCash(this.cashList[index]);
              },
            ),
            onTap: () async {
              print('value');
                // var cash = await navigateToEntryForm(context, this.cashList[index]);
                // if (cash != null) editCash(cash);              
            },
          ),
        );
      },
    );
  }
  void updateListView(int cashType) async {
    final Future<Database> dbFuture = dbHelper.initDb();
    List<Map<String, dynamic>> cashListFuture;
    switch (cashType) {
      case 0:
        cashListFuture = await dbHelper.select('cash', filter: 'createdAt DESC');
        break;
      case 1:
        cashListFuture = await dbHelper.search('cash', 'type=?', '0', order : 'createdAt DESC');
        break;
      case 2:
        cashListFuture = await dbHelper.search('cash', 'type=?', '1', order : 'createdAt DESC');
        break;
      default:
        cashListFuture = await dbHelper.select('cash', filter: 'createdAt DESC');
    }
    List<Cash> itemList = List<Cash>();
    for(int i=0; i<cashListFuture.length; i++) {
      itemList.add(Cash.fromMap(cashListFuture[i]));
    }
    setState(() {
      this.cashList = itemList;
      this.count = itemList.length;      
    });
  }

  void editCash(Cash cash) async {
    Map<String, dynamic> item = cash.toMap();
    int result = await dbHelper.update('cash', item, item['id']);
    if(result > 0) {
      updateListView(filter);
    }
  }  
  void deleteCash(Cash cash) async {
    Map<String, dynamic> item = cash.toMap();
    int result = await dbHelper.delete('cash', item['id']);
    if(result > 0) {
      updateListView(filter);
    }    
  }
}