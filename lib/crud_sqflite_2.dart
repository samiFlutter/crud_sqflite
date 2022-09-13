import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  State<SqliteApp> createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  final textController = TextEditingController();
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Grocery>>(
          future: DatabaseHelper.instance.getGroceries(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('loading...'),
              );
            }
            return snapshot.data!.isEmpty
                ? Center(
                    child: Text('NO Groceries in list.'),
                  )
                : ListView(
                    children: snapshot.data!.map((grocery) {
                      return Center(
                        child: Card(
                          color: selectedId == grocery.id
                              ? Colors.amber
                              : Colors.white,
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                if (selectedId == null) {
                                  textController.text = grocery.name;
                                  selectedId = grocery.id;
                                } else {
                                  textController.text = "";
                                  selectedId = null;
                                }
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                DatabaseHelper.instance.remove(grocery.id!);
                              });
                            },
                            title: Text(grocery.name),
                          ),
                        ),
                      );
                    }).toList(),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          selectedId != null
              ? await DatabaseHelper.instance
                  .update(Grocery(id: selectedId, name: textController.text))
              : await DatabaseHelper.instance.add(
                  Grocery(name: textController.text),
                );
          setState(() {
            textController.clear();
            selectedId = null;
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class Grocery {
  final int? id;
  final String name;
  Grocery({this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) => new Grocery(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE groceries(
      id INTEGER PRIMARY KEY,
      name TEXT
    )
''');
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var groceries = await db.query(
      'groceries',
      orderBy: 'name',
    );

    List<Grocery> groceriesList = groceries.isNotEmpty
        ? groceries.map((c) => Grocery.fromMap(c)).toList()
        : [];

    return groceriesList;
  }

  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db
        .rawUpdate('UPDATE groceries SET name = ? WHERE id = ${grocery.id}', [
      '${grocery.name}',
    ]);
    // return await db.update('groceries', grocery.toMap(),
    //     where: 'id : ?', whereArgs: [grocery.id]);
  }
}
