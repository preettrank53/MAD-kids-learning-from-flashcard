import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/flashcard_model.dart';

/// Database Helper - SQLite Database Management
/// 
/// Singleton class that handles all database operations for the Kids Learning App.
/// Lab 6: Database Design & CRUD Operations
/// 
/// This class:
/// - Creates and initializes the SQLite database
/// - Defines the database schema (flashcards table)
/// - Provides CRUD methods for Flashcard operations
class DatabaseHelper {
  // ============================================================================
  // SINGLETON PATTERN - Ensures only one database instance exists
  // ============================================================================
  
  /// Private constructor prevents external instantiation
  DatabaseHelper._privateConstructor();
  
  /// Single instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  
  /// Database instance - initialized when first accessed
  static Database? _database;
  
  // ============================================================================
  // DATABASE CONFIGURATION
  // ============================================================================
  
  /// Database name stored on the device
  static const String _databaseName = 'kids_learning.db';
  
  /// Database version - Incrementing to 2 for Phase 2 (SRS Features)
  static const int _databaseVersion = 2;
  
  /// Table name for flashcards
  static const String tableFlashcards = 'flashcards';
  
  // ============================================================================
  // COLUMN NAMES - Used in SQL queries
  // ============================================================================
  
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnCategory = 'category';
  static const String columnColorValue = 'colorValue';
  
  // Phase 2 Columns (SRS)
  static const String columnEaseFactor = 'easeFactor';
  static const String columnInterval = 'interval';
  static const String columnRepetitions = 'repetitions';
  static const String columnDueDate = 'dueDate';
  
  // ============================================================================
  // DATABASE GETTER - Lazy initialization
  // ============================================================================
  
  /// Returns the database instance, creating it if it doesn't exist
  Future<Database> get database async {
    // If database already exists, return it
    if (_database != null) return _database!;
    
    // Otherwise, initialize the database
    _database = await _initDB();
    return _database!;
  }
  
  // ============================================================================
  // DATABASE INITIALIZATION
  // ============================================================================
  
  /// Initializes the database
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // Handling migration
    );
  }
  
  // ============================================================================
  // SCHEMA CREATION & MIGRATION
  // ============================================================================
  
  /// Creates the database schema (V2)
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFlashcards (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnColorValue INTEGER NOT NULL,
        $columnEaseFactor REAL DEFAULT 2.5,
        $columnInterval INTEGER DEFAULT 0,
        $columnRepetitions INTEGER DEFAULT 0,
        $columnDueDate INTEGER DEFAULT 0
      )
    ''');
    
    // Seed Starter Data
    print('🌱 Seeding initial data...');
    List<Map<String, dynamic>> initialCards = [
      // Animals (Soft Red)
      {'title': 'Lion', 'category': 'Animals', 'colorValue': 0xFFFF4B4B},
      {'title': 'Elephant', 'category': 'Animals', 'colorValue': 0xFFFF4B4B},
      {'title': 'Tiger', 'category': 'Animals', 'colorValue': 0xFFFF4B4B},
      
      // Space (Indigo)
      {'title': 'Moon', 'category': 'Space', 'colorValue': 0xFF6C5CE7},
      {'title': 'Sun', 'category': 'Space', 'colorValue': 0xFF6C5CE7},
      {'title': 'Mars', 'category': 'Space', 'colorValue': 0xFF6C5CE7},
      {'title': 'Rocket', 'category': 'Space', 'colorValue': 0xFF6C5CE7},

      // Fruits (Orange)
      {'title': 'Apple', 'category': 'Fruits', 'colorValue': 0xFFFF9F43},
      {'title': 'Banana', 'category': 'Fruits', 'colorValue': 0xFFFF9F43},
      {'title': 'Grape', 'category': 'Fruits', 'colorValue': 0xFFFF9F43},

      // Numbers (Green)
      {'title': 'One', 'category': 'Numbers', 'colorValue': 0xFF58CC02},
      {'title': 'Two', 'category': 'Numbers', 'colorValue': 0xFF58CC02},
      {'title': 'Three', 'category': 'Numbers', 'colorValue': 0xFF58CC02},
    ];

    for (var card in initialCards) {
      await db.insert(tableFlashcards, card);
    }

    print('✅ Database table "$tableFlashcards" created and seeded successfully (V2)');
  }

  /// Handles creating new columns when upgrading from V1 to V2
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      print('🔄 Upgrading Database V$oldVersion -> V$newVersion (Adding SRS Columns)');
      await db.execute('ALTER TABLE $tableFlashcards ADD COLUMN $columnEaseFactor REAL DEFAULT 2.5');
      await db.execute('ALTER TABLE $tableFlashcards ADD COLUMN $columnInterval INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE $tableFlashcards ADD COLUMN $columnRepetitions INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE $tableFlashcards ADD COLUMN $columnDueDate INTEGER DEFAULT 0');
    }
  }
  
  // ============================================================================
  // CRUD OPERATIONS - Lab 6 Phase 2
  // ============================================================================
  
  /// CREATE - Inserts a new flashcard into the database
  /// 
  /// Returns the id of the newly inserted row
  /// 
  /// Example:
  /// ```dart
  /// Flashcard card = Flashcard(
  ///   title: 'Lion',
  ///   category: 'Animals',
  ///   colorValue: 0xFFFF6B6B,
  /// );
  /// int id = await DatabaseHelper.instance.insertFlashcard(card);
  /// print('Inserted flashcard with id: $id');
  /// ```
  Future<int> insertFlashcard(Flashcard flashcard) async {
    Database db = await database;
    
    // Insert the flashcard into the database
    // conflictAlgorithm: replace ensures duplicate entries are updated
    int id = await db.insert(
      tableFlashcards,
      flashcard.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    print('✅ Inserted flashcard: ${flashcard.title} with id: $id');
    return id;
  }
  
  /// READ - Retrieves all flashcards from the database
  /// 
  /// Returns a List of Flashcard objects
  /// 
  /// Example:
  /// ```dart
  /// List<Flashcard> flashcards = await DatabaseHelper.instance.getFlashcards();
  /// print('Total flashcards: ${flashcards.length}');
  /// ```
  Future<List<Flashcard>> getFlashcards() async {
    Database db = await database;
    
    // Query all rows from the flashcards table
    final List<Map<String, dynamic>> maps = await db.query(tableFlashcards);
    
    // Convert the List<Map<String, dynamic>> into a List<Flashcard>
    List<Flashcard> flashcards = List.generate(maps.length, (i) {
      return Flashcard.fromMap(maps[i]);
    });
    
    print('📖 Retrieved ${flashcards.length} flashcards from database');
    return flashcards;
  }
  
  /// READ - Retrieves flashcards by category
  /// 
  /// Returns a List of Flashcard objects matching the specified category
  /// 
  /// Example:
  /// ```dart
  /// List<Flashcard> animals = await DatabaseHelper.instance.getFlashcardsByCategory('Animals');
  /// ```
  Future<List<Flashcard>> getFlashcardsByCategory(String category) async {
    Database db = await database;
    
    // Query rows where category matches
    final List<Map<String, dynamic>> maps = await db.query(
      tableFlashcards,
      where: '$columnCategory = ?',
      whereArgs: [category],
    );
    
    // Convert to List<Flashcard>
    List<Flashcard> flashcards = List.generate(maps.length, (i) {
      return Flashcard.fromMap(maps[i]);
    });
    
    print('📖 Retrieved ${flashcards.length} flashcards in category: $category');
    return flashcards;
  }
  
  /// UPDATE - Updates an existing flashcard in the database
  /// 
  /// Returns the number of rows affected (should be 1 if successful)
  /// 
  /// Example:
  /// ```dart
  /// Flashcard card = existingCard.copyWith(title: 'Tiger');
  /// int result = await DatabaseHelper.instance.updateFlashcard(card);
  /// print('Updated $result flashcard(s)');
  /// ```
  Future<int> updateFlashcard(Flashcard flashcard) async {
    Database db = await database;
    
    // Update the flashcard where id matches
    int count = await db.update(
      tableFlashcards,
      flashcard.toMap(),
      where: '$columnId = ?',
      whereArgs: [flashcard.id],
    );
    
    print('✏️ Updated flashcard id ${flashcard.id}: ${flashcard.title} ($count row(s) affected)');
    return count;
  }
  
  /// DELETE - Removes a flashcard from the database
  /// 
  /// Returns the number of rows deleted (should be 1 if successful)
  /// 
  /// Example:
  /// ```dart
  /// int result = await DatabaseHelper.instance.deleteFlashcard(5);
  /// print('Deleted $result flashcard(s)');
  /// ```
  Future<int> deleteFlashcard(int id) async {
    Database db = await database;
    
    // Delete the flashcard where id matches
    int count = await db.delete(
      tableFlashcards,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    
    print('🗑️ Deleted flashcard id $id ($count row(s) affected)');
    return count;
  }
  
  /// DELETE ALL - Removes all flashcards from the database
  /// 
  /// Returns the number of rows deleted
  /// 
  /// WARNING: This will delete ALL flashcards!
  Future<int> deleteAllFlashcards() async {
    Database db = await database;
    
    int count = await db.delete(tableFlashcards);
    
    print('🗑️ Deleted all flashcards ($count row(s) affected)');
    return count;
  }
  
  // ============================================================================
  // DATABASE CLEANUP (For Testing)
  // ============================================================================
  
  /// Closes the database connection
  /// 
  /// Should be called when the app is shutting down or during testing
  Future<void> close() async {
    Database db = await database;
    await db.close();
  }
  
  /// Deletes the entire database file
  /// 
  /// WARNING: This will permanently delete all data!
  /// Only use for testing or reset functionality
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
    print('🗑️ Database deleted: $path');
  }
}
