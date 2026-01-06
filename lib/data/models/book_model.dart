class BookModel {
  final String id;
  final String title;
  final String authors;
  final String thumbnail;
  final String description;
  final String publishedDate;
  final String category;
  final double rating;
  final int ratingsCount;
  final int pageCount;
  final bool isFree;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.thumbnail,
    required this.description,
    required this.publishedDate,
    required this.category,
    required this.rating,
    required this.ratingsCount,
    required this.pageCount,
    required this.isFree,
  });

  // ===============================
  // 1️⃣ FROM GOOGLE BOOKS API
  // ===============================
  factory BookModel.fromApiJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final saleInfo = json['saleInfo'] ?? {};
    final accessInfo = json['accessInfo'] ?? {};

    bool isFree = false;
    if (saleInfo['saleability'] == 'FREE' ||
        accessInfo['accessViewStatus'] == 'FULL_PUBLIC_DOMAIN' ||
        (saleInfo['isEbook'] == true && saleInfo['listPrice'] == null)) {
      isFree = true;
    }

    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      authors: volumeInfo['authors'] != null
          ? (volumeInfo['authors'] as List).join(', ')
          : 'Unknown Author',
      thumbnail: volumeInfo['imageLinks']?['thumbnail'] ?? '',
      description: volumeInfo['description'] ?? 'No Description',
      publishedDate: volumeInfo['publishedDate'] ?? 'Unknown',
      category: volumeInfo['categories'] != null
          ? volumeInfo['categories'][0]
          : 'General',
      rating: volumeInfo['averageRating'] != null
          ? (volumeInfo['averageRating'] as num).toDouble()
          : 0.0,
      ratingsCount: volumeInfo['ratingsCount'] ?? 0,
      pageCount: volumeInfo['pageCount'] ?? 0,
      isFree: isFree,
    );
  }

  // ===============================
  // 2️⃣ TO FIRESTORE
  // ===============================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'thumbnail': thumbnail,
      'description': description,
      'publishedDate': publishedDate,
      'category': category,
      'rating': rating,
      'ratingsCount': ratingsCount,
      'pageCount': pageCount,
      'isFree': isFree,
    };
  }

  // ===============================
  // 3️⃣ FROM FIRESTORE
  // ===============================
  factory BookModel.fromFirestore(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      authors: json['authors'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      description: json['description'] ?? '',
      publishedDate: json['publishedDate'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      ratingsCount: json['ratingsCount'] ?? 0,
      pageCount: json['pageCount'] ?? 0,
      isFree: json['isFree'] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'authors': authors.split(', '), // store as List<String> for Firestore
    'thumbnail': thumbnail,
    'description': description,
    'publishedDate': publishedDate,
    'category': category,
    'rating': rating,
    'ratingsCount': ratingsCount,
    'pageCount': pageCount,
    'isFree': isFree,
  };
}
}
