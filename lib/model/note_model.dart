// to store later our note create table
final String tableNotes = 'notes';

// fields
class NoteFields {
  // column names so it will be string
  // fields names == column names later in our database
  // in SQL by default the before id _
  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class NoteModel {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const NoteModel({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });
}
// why we used a model?
// It clarifies your code by defining the structure of a note.
// It prevents errors by ensuring data types are correct (e.g., title can't be a number).
// You can reuse this Note model anywhere in your app where you need to work with notes.
// You can easily serialize/deserialize notes for data persistence or API communication.
