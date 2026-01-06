import 'package:book_app/features/cart/view/cart_page.dart';
import 'package:get/get.dart';
import 'package:book_app/data/models/book_model.dart';
import '../data/cart_repository.dart';

class CartController extends GetxController {
  final CartRepository repository;

  CartController(this.repository);

  final RxList<BookModel> cartItems = <BookModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    isLoading.value = true;
    try {
      final items = await repository.fetchCart();
      cartItems.assignAll(items);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(BookModel book) async {
    if (isInCart(book)) return;
    await repository.addBook(book);
    cartItems.add(book);
  }

  Future<void> removeFromCart(BookModel book) async {
    await repository.removeBook(book.id);
    cartItems.removeWhere((b) => b.id == book.id);
  }

  Future<void> clearCart() async {
    await repository.clearCart();
    cartItems.clear();
  }

  bool isInCart(BookModel book) {
    return cartItems.any((b) => b.id == book.id);
  }
}
