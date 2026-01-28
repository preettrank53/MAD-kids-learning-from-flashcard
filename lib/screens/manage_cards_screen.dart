import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/flashcard_model.dart';

class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Flashcard> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await _dbHelper.getFlashcards();
    setState(() {
      _cards = cards;
      _isLoading = false;
    });
  }

  Future<void> _deleteCard(int id) async {
    await _dbHelper.deleteFlashcard(id);
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cards'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cards.isEmpty
              ? const Center(child: Text("No cards yet."))
              : ListView.builder(
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(card.colorValue).withOpacity(0.2),
                        child: Icon(Icons.flash_on, color: Color(card.colorValue), size: 16),
                      ),
                      title: Text(card.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(card.category),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteCard(card.id!),
                      ),
                    );
                  },
                ),
    );
  }
}
