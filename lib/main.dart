import 'package:crudsqflite/crud_sqflite.dart';
import 'package:crudsqflite/crud_sqflite_2.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SqliteApp(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CrudSqflite db = CrudSqflite();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("CRUD APP SQFLITE")),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              OutlinedButton(
                  onPressed: () async {
                    db.createDB();
                  },
                  child: Text('Create DB')),
              OutlinedButton(
                  onPressed: () async {
                    db.insertDB();
                  },
                  child: Text('insert value ')),
              OutlinedButton(
                  onPressed: () async {
                    db.getDBall();
                  },
                  child: Text('get value ')),
              OutlinedButton(
                  onPressed: () async {
                    db.updateDB();
                  },
                  child: Text('update value ')),
              OutlinedButton(
                  onPressed: () async {
                    db.delete();
                  },
                  child: Text('delete value ')),
            ],
          ),
        ),
      ),
    );
  }
}
