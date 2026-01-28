/// Flashcard Data Model
/// 
/// Represents a flashcard entity in the SQLite database.
/// Lab 6: Database Design & CRUD Operations
/// 
/// This model maps to the 'flashcards' table in the local database.
class Flashcard {
  // ============================================================================
  // PROPERTIES - Database Table Columns
  // ============================================================================
  
  /// Unique identifier (Primary Key, auto-incremented by SQLite)
  /// Nullable because it's assigned by the database upon insertion
  int? id;
  
  /// Title of the flashcard (e.g., "Lion", "Circle", "Apple")
  String title;
  
  /// Category the flashcard belongs to (e.g., "Animals", "Shapes", "Fruits")
  String category;
  
  /// Color value stored as an integer (e.g., 0xFFFF6B6B for red)
  /// Used to display colorful cards in the UI
  int colorValue;
  // ============================================================================
  // SRS PROPERTIES - Phase 2: Spaced Repetition System
  // ============================================================================
  
  /// SRS Ease Factor (starts at 2.5)
  double easeFactor;
  
  /// Interval in days until next review
  int interval;
  
  /// Number of successful reviews in a row
  int repetitions;
  
  /// Date when the card is due for review
  DateTime dueDate;

  // ============================================================================
  // CONSTRUCTOR
  // ============================================================================
  
  /// Creates a Flashcard object
  Flashcard({
    this.id,
    required this.title,
    required this.category,
    required this.colorValue,
    this.easeFactor = 2.5,
    this.interval = 0,
    this.repetitions = 0,
    DateTime? dueDate,
  }) : dueDate = dueDate ?? DateTime.now(); // Default to now (ready to learn)
  
  // ============================================================================
  // DATABASE CONVERSION METHODS
  // ============================================================================
  
  /// Converts the Flashcard object to a Map for database insertion/update
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'colorValue': colorValue,
      'easeFactor': easeFactor,
      'interval': interval,
      'repetitions': repetitions,
      'dueDate': dueDate.millisecondsSinceEpoch,
    };
  }
  
  /// Factory constructor to create a Flashcard object from database Map
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'] as int?,
      title: map['title'] as String,
      category: map['category'] as String,
      colorValue: map['colorValue'] as int,
      easeFactor: map['easeFactor'] as double? ?? 2.5,
      interval: map['interval'] as int? ?? 0,
      repetitions: map['repetitions'] as int? ?? 0,
      dueDate: map['dueDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
          : null,
    );
  }
  
  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  @override
  String toString() {
    return 'Flashcard{id: $id, title: $title, category: $category, ease: $easeFactor, due: $dueDate}';
  }
  
  /// Creates a copy of this Flashcard with optional field updates
  Flashcard copyWith({
    int? id,
    String? title,
    String? category,
    int? colorValue,
    double? easeFactor,
    int? interval,
    int? repetitions,
    DateTime? dueDate,
  }) {
    return Flashcard(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
