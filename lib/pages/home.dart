import 'package:cashflow/helpers/dbhelper.dart';
import 'package:cashflow/pages/cashform.dart';
import 'package:cashflow/pages/categorypage.dart';
import 'package:cashflow/pages/riwayat.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cashflow/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  int _selectedTabIndex = 0;  
  List<Widget> pages;
  Widget _currentPage;
  List<String> title = [
    'CashFlow',
    'Kategori',
    'Tambah Transaksi',
    'Riwayat',
    'Tentang'
  ];
  @override
  void initState() {
    pages = <Widget>[
      MainPage(),
      CategoryPage(),
      CashForm(changeTab: onNavbarTapped),
      Riwayat(),
      Text('Tentang')
    ];      
    _currentPage = MainPage();
    dbHelper.initDb();
    super.initState();
  }
  
  void onNavbarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      _currentPage = pages[index];
    });
  }  

  @override
  Widget build(BuildContext context) {
    final _bottomNavbarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Beranda')
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        title: Text('Kategori')
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add),
        title: Text('Tambah'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        title: Text('Riwayat')
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.info),
        title: Text('Tentang')
      )
    ];
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(
        //   Icons.attach_money
        // ),
        elevation: _selectedTabIndex == 3 ? 0 : 2,
        title: Align(
          alignment: Alignment.center,
          child: Text(title[_selectedTabIndex]),
        )
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavbarItems,
        currentIndex: _selectedTabIndex,
        onTap: onNavbarTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColorDark,
      ),
    );
  }

  void navigateToCashForm(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return CashForm();
      }
    ));
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Main page'),
    );
  }
}

