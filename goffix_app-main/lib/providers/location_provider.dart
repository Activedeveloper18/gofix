import 'dart:io';
import 'package:goffix/models/location_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocProvider {
  late Database _database;
  static final LocProvider db = LocProvider._();
  LocProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'goffixLoc.db');
    print('db location : ' + path);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Location('
          'loc_Id TEXT,'
          'loc_name TEXT,'
          'loc_cityid TEXT,'
          'loc_astat TEXT'
          ')');
    });
  }

  // Insert Post on database
  createLocation(LocModel newPosts) async {
    // await deleteAllEmployees();
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.insert('Location', newPosts.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Location');

    return res;
  }

  Future<List<LocModel>> getAllLocations() async {
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.rawQuery("SELECT * FROM Location");

    List<LocModel> list =
        res.isNotEmpty ? res.map((c) => LocModel.fromJson(c)).toList() : [];

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
