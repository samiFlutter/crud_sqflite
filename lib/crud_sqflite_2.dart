import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'grocery_model.dart';
import 'my_databasehelper.dart';

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



