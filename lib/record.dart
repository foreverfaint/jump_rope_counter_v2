import 'package:sqflite/sqflite.dart';
import 'file_system.dart';

const String dbName = "JumpRope";

const String tableName = "RecordItem";

const String columnId = "id";

const String columnCreatedAtUtc = "created_at";

const String columnMediaFilePath = "media_file_path";

const String columnCount = "count";

class Record {
  int id;

  String mediaFilePath;

  num count;

  DateTime createdAtUtc;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnCount: count,
      columnMediaFilePath: mediaFilePath,
      columnCreatedAtUtc: createdAtUtc
    };
  }

  Record(this.mediaFilePath, {this.count: 0})
      : createdAtUtc = DateTime.now().toUtc();

  Record.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.mediaFilePath = map[columnMediaFilePath];
    this.count = map[columnCount];
    this.createdAtUtc = map[columnCreatedAtUtc];
  }
}

class RecordRepository {
  Database _db;

  RecordRepository.open() {
    RecordRepository._openDatabase().then((value) => this._db = value);
  }

  static final FileSystem _fileSystem = FileSystem();

  static Future<Database> _openDatabase() async {
    var databasePath = await _fileSystem.databasePath;
    return await openDatabase(
        databasePath,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
            $columnMediaFilePath TEXT NOT NULL, 
            $columnCount INT INTEGER DEFAULT 0, 
            $columnCreatedAtUtc DATETIME NOT NULL)
          ''');
        });
  }

  bool get isReady => this._db != null && this._db.isOpen;

  Future<Record> insert(Record record) async {
    record.id = await this._db.insert(tableName, record.toMap());
    return record;
  }

  Stream<Record> queryAll({num offset: 0, num limit: 10}) async* {
    yield Record("AA", count: 10);
    yield Record("AA", count: 11);
//    var maps = await this._db.query(tableName,
//        columns: [
//          columnId,
//          columnMediaFilePath,
//          columnCount,
//          columnCreatedAtUtc
//        ],
//        orderBy: columnId + " DESC",
//        offset: offset,
//        limit: limit);
//
//    for (Map<String, dynamic> map in maps) {
//      yield Record.fromMap(map);
//    }
  }

  Future<int> delete(int id) async {
    return await this._db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  dispose() async {
    if (this._db != null) {
      await this._db.close();
      this._db = null;
    }
  }

  close() async {
    await this.dispose();
  }
}