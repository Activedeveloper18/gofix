import 'dart:io';
import 'package:goffix/models/category_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CatProvider {
  late Database _database;
  static final CatProvider db = CatProvider._();
  CatProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'goffixCat.db');
    print('db location : ' + path);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Category('
          'cat_id TEXT,'
          'cat_name TEXT,'
          'cat_astat TEXT'
          ')');
    });
  }

  // Insert Post on database
  createLocation(CatModel newPosts) async {
    // await deleteAllEmployees();
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.insert('Category', newPosts.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Category');

    return res;
  }

  Future<List<CatModel>> getAllLocations() async {
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.rawQuery("SELECT * FROM Category");

    List<CatModel> list =
        res.isNotEmpty ? res.map((c) => CatModel.fromJson(c)).toList() : [];

    return list;
  }

  // Future<int> updatePost(pid) async {
  //   final db = await database;
  //   await Future.delayed(const Duration(seconds: 2));

  //   int res =
  //       await db.rawUpdate("UPDATE Posts set issaved=1 where p_id = ?", [pid]);

  //   return res;
  // }
}
