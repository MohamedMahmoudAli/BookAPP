// screens/book_details_page.dart
import 'package:book_app/core/controllers/nav_controller.dart';
import 'package:book_app/data/models/book_model.dart';
import 'package:book_app/features/cart/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookDetailsPage extends StatelessWidget {
  final BookModel book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        final bool isInCart = cartController.isInCart(book);

        return CustomScrollView(
          slivers: [
            _buildAppBar(context, isInCart, cartController),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildBookInfo(),
                  const SizedBox(height: 24),
                  _buildStats(),
                  const SizedBox(height: 16),
                  _buildRatingInfo(),
                  const SizedBox(height: 24),
                  _buildDescription(),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, isInCart, cartController),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // ================= APP BAR =================
  SliverAppBar _buildAppBar(
    BuildContext context,
    bool isInCart,
    CartController cartController,
  ) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: const Color(0xFF6C63FF),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            isInCart ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () {
            _toggleCart(context, isInCart, cartController);
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6C63FF),
                    const Color(0xFF8B7FFF).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Hero(tag: 'book_${book.title}', child: _buildCover()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= COVER =================
  Widget _buildCover() {
    return Container(
      width: 180,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: book.thumbnail.isNotEmpty
            ? Image.network(
                book.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholderCover(),
              )
            : _placeholderCover(),
      ),
    );
  }

  Widget _placeholderCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.3),
            const Color(0xFF8B7FFF).withOpacity(0.3),
          ],
        ),
      ),
      child: const Icon(Icons.book, size: 80, color: Colors.white),
    );
  }

  // ================= BOOK INFO =================
  Widget _buildBookInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF8B7FFF)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              book.category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            book.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 18,
                color: Color(0xFF6C63FF),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  book.authorsAsString,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= STATS / RATING / DESCRIPTION =================
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildStatCard(
            Icons.calendar_today,
            _formatDate(book.publishedDate),
            'Published',
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            book.isFree ? Icons.workspace_premium : Icons.payments,
            book.isFree ? 'Free' : 'Paid',
            'Access',
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            Icons.menu_book,
            book.pageCount > 0 ? book.pageCount.toString() : 'N/A',
            'Pages',
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty || date == 'Unknown') return 'N/A';
    if (date.length == 4) return date;
    return date.split('-').first;
  }

  Widget _buildRatingInfo() {
    if (book.rating <= 0 && book.ratingsCount <= 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (book.rating > 0) ...[
              const Icon(Icons.star, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Text(
                book.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text('/ 5', style: TextStyle(color: Colors.grey[600])),
            ],
            if (book.rating > 0 && book.ratingsCount > 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: 1,
                height: 30,
                color: Colors.grey[300],
              ),
            if (book.ratingsCount > 0)
              Text(
                '${book.ratingsCount} Reviews',
                style: TextStyle(color: Colors.grey[700]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              book.description.isNotEmpty
                  ? book.description
                  : 'No description available.',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ACTION BUTTONS =================
  Widget _buildActionButtons(
    BuildContext context,
    bool isInCart,
    CartController cartController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => _toggleCart(context, isInCart, cartController),
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart
                    ? Colors.red.shade400
                    : const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isInCart ? 'Remove from Cart' : 'Add to Cart',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preview coming soon!')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Preview',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CART ACTION =================
  void _toggleCart(
    BuildContext context,
    bool isInCart,
    CartController cartController,
  ) {
    if (isInCart) {
      cartController.removeFromCart(book);
    } else {
      cartController.addToCart(book);
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isInCart ? Icons.remove_circle : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isInCart
                    ? '${book.title} removed from cart'
                    : '${book.title} added to cart',
              ),
            ),
          ],
        ),
        backgroundColor: isInCart ? Colors.red.shade400 : Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2), // Automatically disappears
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: isInCart ? 'Undo' : 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            if (isInCart) {
              cartController.addToCart(book); // Undo remove
            } else {
              Navigator.pop(context);
              Get.find<NavController>().changeIndex(2); // Go to cart
            }
          },
        ),
      ),
    );
  }
}

Widget _buildStatCard(IconData icon, String value, String label) {
  Color iconColor = const Color(0xFF6C63FF);
  Color valueColor = const Color(0xFF2D3142);

  if (label == 'Access') {
    if (value == 'Free') {
      iconColor = Colors.green;
      valueColor = Colors.green.shade700;
    } else if (value == 'Paid') {
      iconColor = Colors.orange;
      valueColor = Colors.orange.shade700;
    }
  }

  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    ),
  );
}
