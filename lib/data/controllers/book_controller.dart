import 'package:book_app/data/models/book_model.dart';
import 'package:book_app/data/services/book_services.dart';
import 'package:get/get.dart';
import 'dart:developer';

class BookController extends GetxController {
  final BookServices bookServices = BookServices();

  var books = <BookModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentQuery = 'Flutter'.obs;

  @override
  void onInit() {
    super.onInit();
    searchBooks('Flutter');
  }

  Future<void> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      errorMessage.value = 'Please enter a search term';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    currentQuery.value = query;

    try {
      log('🔄 Searching for: $query');
      
      final results = await bookServices.fetchBooks(query);

      if (results.isEmpty) {
        log('📭 No books found for query: $query');
        books.clear();
        errorMessage.value = 'No books found for "$query"';
      } else {
        books.value = results.map((json) => BookModel.fromJson(json)).toList();
        log('✅ Successfully loaded ${books.length} books');
      }
    } catch (e) {
      log('❌ Error in searchBooks: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      books.clear();
      
      // عرض snackbar للخطأ
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method لتحديث البحث
  void refreshSearch() {
    searchBooks(currentQuery.value);
  }

  // Method للبحث حسب الفئة
  void searchByCategory(String category) {
    searchBooks('subject:$category');
  }

  // Method للبحث حسب المؤلف
  void searchByAuthor(String author) {
    searchBooks('inauthor:$author');
  }
}