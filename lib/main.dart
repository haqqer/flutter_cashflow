import 'package:cashflow/pages/cashform.dart';
import 'package:cashflow/pages/riwayat.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/pages/home.dart';

void main() => runApp(MyApp());

final key = GlobalKey<CashFormState>();
final riwayatKey = GlobalKey<RiwayatState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CashFlow',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Home(),
    );
  }
}