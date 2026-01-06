import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_app/data/models/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CartRepository({required this.firestore, required this.auth});

  String get _userId {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return user.uid;
  }

  Future<List<BookModel>> fetchCart() async {
    final snapshot = await firestore
        .collection('carts')
        .doc(_userId)
        .collection('books')
        .get();

    return snapshot.docs.map((doc) => BookModel.fromFirestore(doc.data())).toList();
  }

  Future<void> addBook(BookModel book) async {
    await firestore
        .collection('carts')
        .doc(_userId)
        .collection('books')
        .doc(book.id)
        .set(book.toMap());
  }

  Future<void> removeBook(String bookId) async {
    await firestore
        .collection('carts')
        .doc(_userId)
        .collection('books')
        .doc(bookId)
        .delete();
  }

  Future<void> clearCart() async {
    final booksCollection = firestore.collection('carts').doc(_userId).collection('books');
    final snapshot = await booksCollection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
