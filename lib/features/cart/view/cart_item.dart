import 'package:book_app/data/models/book_model.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final BookModel book;
  final VoidCallback onRemove;

  const CartItem({required this.book, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Image.network(book.thumbnail, width: 50, fit: BoxFit.cover),
        title: Text(book.title),
        subtitle: Text(book.authors),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
