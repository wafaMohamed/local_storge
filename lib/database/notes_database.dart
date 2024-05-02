import 'package:local_storge/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Class representing the database and its operations
class NotesDataBase {
  // Private constructor to prevent direct instantiation
  NotesDataBase._();

  // Singleton instance for accessing the database
  static final NotesDataBase instanceDb = NotesDataBase._();

  // Database instance
  static Database? _database;

  // Open the database (asynchronous for initialization)
  Future<Database> get database async {
    if (_database != null) return _database!; // Return existing instance

    final dbPath = await getDatabasesPath(); // Get database storage path
    final path = join(dbPath, 'notes.db'); // Join path with filename

    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    return _database!;
  }

  // Create the database schema when it doesn't exist
  void _createDB(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String boolType = 'BOOLEAN NOT NULL';
    const String intType = 'INTEGER NOT NULL';
    const String textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableNotes (
        ${NoteFields.id} $idType,
        ${NoteFields.isImportant} $boolType,
        ${NoteFields.number} $intType,
        ${NoteFields.title} $textType,
        ${NoteFields.description} $textType,
        ${NoteFields.time} $textType
      )
    ''');
  }

  // 1- create operation: Insert a new note into the database
  Future<NotesModel> createOperation(NotesModel notes) async {
    final Database db = await database;
    final List<String> columns = [
      NoteFields.title,
      NoteFields.description,
      NoteFields.time,
    ];
    final List<String> values = [
      notes.title,
      notes.description,
      notes.createdTime.toIso8601String(),
    ];
    final int id = await db.rawInsert(
        "INSERT INTO $tableNotes (${columns.join(', ')}) VALUES (?, ?, ?)",
        values);
    return notes.copy(id: id);
  }

  // 2- Read operation: Get all notes from the database
  Future<NotesModel> readNotes(int id) async {
    final Database db = await instanceDb.database;
    final List<Map<String, Object?>> map = await db.query(tableNotes,
        columns: NoteFields.values,
        // don't put id instead of ? - to be more secure inside whereArgs and if there are more args add more ? and comma after args
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      return NotesModel.fromMap(map.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // 2-1- Read All notes
  Future<List<NotesModel>> readAllNotes() async {
    final Database db = await instanceDb.database;
    // ASC = ascending
    final orderBy = "${NoteFields.time} ASC";

    final List<Map<String, Object?>> result =
        await db.query(tableNotes, orderBy: orderBy);

    return result
        .map((Map<String, Object?> json) => NotesModel.fromMap(json))
        .toList();
  }

  // 3- Update operation: Update a note in the DB
  Future<int> updateOperation(NotesModel notes) async {
    final Database db = await instanceDb.database;
    return db.update(tableNotes, notes.toMap(),
        where: '${NoteFields.id} = ?', whereArgs: [notes.id]);
  }

  // Close the database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
