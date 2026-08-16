class Book {
  final int number;
  final String title;
  final String originalTitle;
  final String releaseDate;
  final String description;
  final int pages;
  final String cover;

  const Book({
    required this.number,
    required this.title,
    required this.originalTitle,
    required this.releaseDate,
    required this.description,
    required this.pages,
    required this.cover,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      number: json['number'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      originalTitle: json['originalTitle'] as String? ?? '',
      releaseDate: json['releaseDate'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      pages: json['pages'] as int? ?? 0,
      cover: json['cover'] as String? ?? '',
    );
  }
}
