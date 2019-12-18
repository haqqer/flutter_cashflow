import 'package:flutter/material.dart';
import 'package:cashflow/models/category.dart';
import 'package:cashflow/helpers/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class CategoryPage extends StatefulWidget {
  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<CategoryPage> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  Category category;
  List<Category> categoryList;

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // tabController = TabController(vsync: this, length: 3);
    updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: allTransaction(textStyle),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add
          ),
          onPressed: () {
            formDialog(context, null);
          },
        ),
      ),
    );
  }
  Widget allTransaction(TextStyle textStyle) {
    if(category != null && categoryList.length < 1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.warning,
              size: 48.0,
            ),
            Divider(),
            Text(
              'Kategori Kosong',
              style: TextStyle(
                fontSize: 24.0
              ),
            )
          ],
        ),
      );
    }
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
                Icons.turned_in
              ),
            ),
            title: Text(this.categoryList[index].name, style: textStyle),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                deleteCategory(this.categoryList[index]);
              },
            ),
            onTap: () async {
              print(this.categoryList[index]);
              formDialog(context, this.categoryList[index]);
                // var category = await navigateToEntryForm(context, this.categoryList[index]);
                // if (category != null) editCategory(category);              
            },
          ),
        );
      },
    );
  }
  formDialog(BuildContext context, Category categoryItem) {
    print('kategori item');
    if(categoryItem != null) {
      nameController.text = categoryItem.name;
    }
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Input Kategori'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Nama'
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Simpan'),
            onPressed: () {
              if(categoryItem != null) {
                categoryItem.name = nameController.text;
                editCategory(categoryItem);
              } else {
                category = Category(nameController.text);
                addCategory(category);
              }
              updateListView();
              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
  }
  void updateListView() async {
    final Future<Database> dbFuture = dbHelper.initDb();
    List<Map<String, dynamic>> categoryListFuture = await dbHelper.select('category', filter: 'createdAt DESC');
    print('check');
    List<Category> itemList = List<Category>();
    print(categoryListFuture);
    for(int i=0; i<categoryListFuture.length; i++) {
      print(categoryListFuture[i]);
      itemList.add(Category.fromMap(categoryListFuture[i]));
    }
    // print(itemList);
    setState(() {
      this.categoryList = itemList;
      this.count = itemList.length;      
    });
  }
  void addCategory(Category category) async {
    await dbHelper.insert('category', category.toMap());
  }  
  void editCategory(Category category) async {
    print('edit kategori');
    Map<String, dynamic> item = category.toMap();
    print(item);
    int result = await dbHelper.update('category', item, item['id']);
    if(result > 0) {
      updateListView();
    }
  }  
  void deleteCategory(Category category) async {
    Map<String, dynamic> item = category.toMap();
    int result = await dbHelper.delete('category', item['id']);
    if(result > 0) {
      updateListView();
    }    
  }
}