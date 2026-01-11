/// Flashcard Model
/// 
/// Represents a single flashcard with a question and answer.
class FlashcardModel {
  final String id;
  final String question;
  final String answer;
  final String? imageUrl; // Optional image for visual learning
  final String category;   // e.g., 'Math', 'Alphabet', 'Animals'
  
  FlashcardModel({
    required this.id,
    required this.question,
    required this.answer,
    this.imageUrl,
    required this.category,
  });
  
  /// Convert model to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
  
  /// Create model from JSON
  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      imageUrl: json['imageUrl'],
      category: json['category'],
    );
  }
}
