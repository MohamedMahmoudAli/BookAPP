// screens/book_details_page.dart
import 'package:book_app/core/controllers/nav_controller.dart';
import 'package:book_app/features/cart/controller/cart_controller.dart';
import 'package:book_app/features/cart/view/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:book_app/data/models/book_model.dart';
import 'package:get/get.dart';

class BookDetailsPage extends StatefulWidget {
  final BookModel book;

  const BookDetailsPage({super.key, required this.book});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late CartController cartController;

  @override
  void initState() {
    super.initState();
    cartController = Get.find<CartController>();
  }

  // =========================
  // ✅ SnackBar helper (disappears after 2 seconds)
  // =========================
  void _showSnackBar(String message, {bool success = true, VoidCallback? action, String? actionLabel}) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? Colors.green.shade400 : Colors.red.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(success ? Icons.check_circle : Icons.remove_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        action: (action != null && actionLabel != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: action,
              )
            : null,
      ),
    );
  }

  void _toggleCart() async {
    final isInCart = cartController.isInCart(widget.book);

    if (isInCart) {
      await cartController.removeFromCart(widget.book);
      _showSnackBar(
        '${widget.book.title} removed from cart',
        success: false,
        action: () => cartController.addToCart(widget.book),
        actionLabel: 'Undo',
      );
    } else {
      await cartController.addToCart(widget.book);
      _showSnackBar(
        '${widget.book.title} added to cart',
        success: true,
        action: () => Get.find<NavController>().changeIndex(2),
        actionLabel: 'View Cart',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.authors,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),
                  Obx(() => _buildActionButtons()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF6C63FF),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Obx(() {
          final isInCart = cartController.isInCart(widget.book);
          return IconButton(
            icon: Icon(
              isInCart ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleCart,
          );
        }),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Hero(
            tag: 'book_${widget.book.title}',
            child: Container(
              width: 160,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.book, size: 80, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final isInCart = cartController.isInCart(widget.book);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _toggleCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: isInCart ? Colors.red.shade400 : const Color(0xFF6C63FF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          isInCart ? 'Remove from Cart' : 'Add to Cart',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
