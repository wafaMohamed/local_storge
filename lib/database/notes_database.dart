import 'package:local_storge/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDataBase {
  // 1 private constructor
  NotesDataBase._();
  // 2 global filed which is our instance and call private constructor,
  static final NotesDataBase instance = NotesDataBase._();
  // 3 create new field for database
  static Database? _dataBase; // optional member of database
  // 4 open database before you can reach and write your data to db
  // open connection method - SQlflite is asynchronous you have to await.
  Future<Database> get database async {
    // 1- return db if it's already excite
    if (_dataBase != null) return _dataBase!;
    // 2- initialize db if it's not excite in notes.db file
    // .db extension when specifying the database path
    /* depends on the platform you're targeting:
       1. Android: Generally not required: On Android, you can usually omit the .db extension when calling openDatabase. The sqflite library handles adding it automatically in most cases.
       2. iOS and other platforms: Might be required: For iOS and some other platforms, explicitly including the .db extension in the path might be necessary for sqflite to recognize the file as a database.*/
    _dataBase = await _initDB('notes.db');
    return _dataBase!;
  }

  // 5 initialize db if it's not excite in notes.db file
  Future<Database> _initDB(String filePath) async {
    // store db in our file storage system.
    // if you want to store db in different location use (path_provider) package.
    final String dbPath = await getDatabasesPath();
    // import path library
    final String path = join(dbPath, filePath);
    // onCreate -> schema
    return await openDatabase(path, version: 1, onCreate: _createDB);
    // so the _createDB method will only executed when only the db is not excite or notes file not exciting
  }

  //6 create db table
  Future<void> _createDB(Database database, int version) async {
    final String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final String booleanType = "BOOLEAN NOT NULL";
    final String intType = "INTEGER NOT NULL";
    final String textType = "TEXT NOT NULL";
    // to create db call execute method
    // triple quotes in to multiline string and structure and columns of table put it in ()
    // you can duplicate tables if you need more :)
    database.execute('''
    CREATE TABLE $tableNotes (
    ${NoteFields.id} $idType,
    ${NoteFields.isImportant} $booleanType,
    ${NoteFields.number} $intType,
    ${NoteFields.title} $textType,
    ${NoteFields.description} $textType,
    ${NoteFields.time} $textType,
    )
    ''');
  }

  //7 close db
  Future<void> close() async {
    final db = await instance.database;
    return db.close();
  }
  // close db
}
// we want to persist some notes
