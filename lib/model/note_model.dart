// to store later our note create table
final String tableNotes = 'notes';

// fields
class NoteFields {
  // column names so it will be string
  // fields names == column names later in our database
  // in SQL by default the before id _
  static List<String> values = [
    // add all fields
    id,
    isImportant,
    number,
    title,
    description,
    time
  ];
  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class NotesModel {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const NotesModel({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  NotesModel copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      NotesModel(
          id: id ?? this.id,
          isImportant: isImportant ?? this.isImportant,
          number: number ?? this.number,
          title: title ?? this.title,
          description: description ?? this.description,
          createdTime: createdTime ?? this.createdTime);

  // Convert the note to a map for database storage
  Map<String, Object?> toMap() => {
        // key: value => key == column name / value == data
        NoteFields.id: id,
        // 1:0 == true: false because this how sql understand
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.number: number,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.time:
            createdTime.toIso8601String(), //2024-05-02T16:51:12.377Z
      };

  static NotesModel fromMap(Map<String, Object?> json) => NotesModel(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String,
        number: json[NoteFields.number] as int,
        description: json[NoteFields.description] as String,
        isImportant: json[NoteFields.isImportant] == 1 ? true : false,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
      );
}
// why we used a model?
// It clarifies your code by defining the structure of a note.
// It prevents errors by ensuring data types are correct (e.g., title can't be a number).
// You can reuse this Note model anywhere in your app where you need to work with notes.
// You can easily serialize/deserialize notes for data persistence or API communication.
