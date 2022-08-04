import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CrudSqflite{
  Database? database;
  createDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mydb.db');


    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY,  value INTEGER)');
        });
  }
  insertDB() async {
    // Insert some records in a transaction
    await database?.transaction((txn) async {
    int id1 = await txn.rawInsert(
    'INSERT INTO Test( value) VALUES( 1234)');
    print('inserted1: $id1');


    });

  }
  getDBall() async{
    List<Map<String, Object?>>? list = await database?.rawQuery('SELECT * FROM Test');
    print(list);
  }

  updateDB()async{
    // Update some record
    int? count = await database?.rawUpdate(
        'UPDATE Test SET value = ? WHERE value = 1234',
        ['9876', ]);
    print('updated: $count');
  }
  delete()async{
    // Delete a record
    int? count = await database
        ?.rawDelete('DELETE FROM Test WHERE value = 9876');
    assert(count == 1);

  }
}