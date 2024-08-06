import 'dart:io';
import 'package:goffix/models/post_model.dart';
import 'package:goffix/models/profile_posts_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  late Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'goffix_test14.db');
    print('db location : ' + path);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Posts('
          'u_id TEXT,'
          'u_nm TEXT,'
          'p_tit TEXT,'
          'u_img TEXT,'
          'u_phn TEXT,'
          'us_typ TEXT,'
          'p_id TEXT,'
          'p_dt DateTime ,'
          'p_priority TEXT,'
          'p_ctyp TEXT,'
          'p_jd TEXT,'
          'u_gender TEXT,'
          'cat_name TEXT,'
          'loc_name TEXT,'
          'report_count TEXT,'
          'issaved TEXT'
          ')');
      await db.execute('CREATE TABLE ProfilePosts('
          'p_uid TEXT,'
          'u_nm TEXT,'
          'p_tit TEXT,'
          'u_img TEXT,'
          'u_phn TEXT,'
          'p_id TEXT,'
          'p_dt DateTime ,'
          'p_priority TEXT,'
          'p_ctyp TEXT,'
          'p_jd TEXT,'
          'cat_name TEXT,'
          'loc_name TEXT,'
          'issaved TEXT'
          ')');
    });
  }

  // Insert Post on database
  createEmployee(PostModel newPosts) async {
    // await deleteAllEmployees();
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.insert('Posts', newPosts.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Posts');

    return res;
  }

  Future<List<PostModel>?> getAllEmployees() async {
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.rawQuery("SELECT * FROM Posts LIMIT 100 OFFSET 10");
    // final res = await db.rawQuery("SELECT * FROM Posts LIMIT 100");

    if (res.isEmpty) {
      return null;
    }
    List<PostModel> list =
        res.isNotEmpty ? res.map((c) => PostModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<dynamic> getUidDetails(uid, pid) async {
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.rawQuery(
        "SELECT * FROM Posts where u_id = ? and p_id = ?", [uid, pid]);

    // List<PostModel> list =
    //     res.isNotEmpty ? res.map((c) => PostModel.fromJson(c)).toList() : [];

    // return list;
    // final result = res.forEach((row) => print(row));

    // return result;
    return res;
  }

  Future<int> updatePost(pid) async {
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));

    int res =
        await db.rawUpdate("UPDATE Posts set issaved=1 where p_id = ?", [pid]);

    return res;
  }

  //*************************************Profile Screen************************************************//

  // Insert Post on database
  createProfilePosts(UserProfilePosts newPosts) async {
    // await deleteAllEmployees();
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.insert('ProfilePosts', newPosts.toJson());

    return res;
  }

  // Get all Posts from Database
  Future<List<UserProfilePosts>?> getAllProfilePosts() async {
    final db = await database;
    await Future.delayed(const Duration(seconds: 2));
    final res = await db.rawQuery("SELECT * FROM ProfilePosts");
    if (res.isEmpty) {
      return null;
    }
    List<UserProfilePosts> list = res.isNotEmpty
        ? res.map((c) => UserProfilePosts.fromJson(c)).toList()
        : [];

    return list;
  }

  // Delete all Profile Posts
  Future<int> deleteAllProfilePosts() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM ProfilePosts');

    return res;
  }
}
