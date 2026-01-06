import 'package:get/get.dart';
import 'package:book_app/data/models/book_model.dart';
import '../data/cart_repository.dart';
import 'package:paymob_payment/paymob_payment.dart';

class CartController extends GetxController {
  final CartRepository repository;

  CartController(this.repository);

  // =======================
  // Existing State
  // =======================

  final RxList<BookModel> cartItems = <BookModel>[].obs;
  final RxBool isLoading = false.obs;

  // =======================
  // Lifecycle
  // =======================

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // =======================
  // Existing Functions
  // =======================

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

  Future<void> payNow() async {
    if (cartItems.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty');
      return;
    }

    try {
      isLoading.value = true;

      final result = await PaymobPayment.instance.pay(
        context: Get.context!,
        currency: "EGP",
        amountInCents: "9.99",
        
        // ✅ CORRECT TYPE
        billingData: PaymobBillingData(
          firstName: "User",
          lastName: "App",
          email: "user@app.com",
          phoneNumber: "01000000000",
          apartment: "NA",
          floor: "NA",
          street: "NA",
          building: "NA",
          city: "Cairo",
          state: "Cairo",
          country: "EG",
          postalCode: "00000",
        ),
      );

      if (result!.success) {
        await clearCart();
        Get.snackbar('Success', 'Payment completed successfully');
      } else {
        Get.snackbar(
          'Payment Failed',
          result.message ?? 'Transaction cancelled',
        );
      }
    } catch (e) {
      Get.snackbar('Payment Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
