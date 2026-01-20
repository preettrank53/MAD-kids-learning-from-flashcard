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
  // CONSTRUCTOR
  // ============================================================================
  
  /// Creates a Flashcard object
  /// 
  /// [id] is optional - null when creating a new flashcard
  /// [title], [category], and [colorValue] are required
  Flashcard({
    this.id,
    required this.title,
    required this.category,
    required this.colorValue,
  });
  
  // ============================================================================
  // DATABASE CONVERSION METHODS
  // ============================================================================
  
  /// Converts the Flashcard object to a Map for database insertion/update
  /// 
  /// Used by SQLite operations (insert, update)
  /// 
  /// Example:
  /// ```dart
  /// Flashcard card = Flashcard(
  ///   title: 'Lion',
  ///   category: 'Animals',
  ///   colorValue: 0xFFFF6B6B,
  /// );
  /// Map<String, dynamic> map = card.toMap();
  /// // Result: {'title': 'Lion', 'category': 'Animals', 'colorValue': 4294923067}
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'colorValue': colorValue,
    };
  }
  
  /// Factory constructor to create a Flashcard object from database Map
  /// 
  /// Used when retrieving data from SQLite
  /// 
  /// Example:
  /// ```dart
  /// Map<String, dynamic> dbMap = {
  ///   'id': 1,
  ///   'title': 'Lion',
  ///   'category': 'Animals',
  ///   'colorValue': 4294923067,
  /// };
  /// Flashcard card = Flashcard.fromMap(dbMap);
  /// ```
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'] as int?,
      title: map['title'] as String,
      category: map['category'] as String,
      colorValue: map['colorValue'] as int,
    );
  }
  
  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  /// Returns a string representation of the Flashcard object
  /// Useful for debugging
  @override
  String toString() {
    return 'Flashcard{id: $id, title: $title, category: $category, colorValue: $colorValue}';
  }
  
  /// Creates a copy of this Flashcard with optional field updates
  /// 
  /// Example:
  /// ```dart
  /// Flashcard original = Flashcard(title: 'Lion', category: 'Animals', colorValue: 0xFF);
  /// Flashcard updated = original.copyWith(title: 'Tiger');
  /// ```
  Flashcard copyWith({
    int? id,
    String? title,
    String? category,
    int? colorValue,
  }) {
    return Flashcard(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
