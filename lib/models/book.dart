const _unchanged = Object();

enum BookStatus {
  wantToRead('want_to_read'),
  reading('reading'),
  completed('completed'),
  paused('paused');

  const BookStatus(this.storageValue);

  final String storageValue;

  static BookStatus fromStorageValue(String value) {
    for (final status in values) {
      if (status.storageValue == value) return status;
    }
    throw FormatException('Unknown book status: $value');
  }
}

/// A book in the user's personal library. IDs are assigned by the database.
class Book {
  Book({
    this.id,
    required String title,
    required String author,
    String? genre,
    String? description,
    String? notes,
    String? coverPath,
    this.status = BookStatus.wantToRead,
    this.totalPages,
    this.currentPage = 0,
    this.isFavorite = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : title = title.trim(),
       author = author.trim(),
       genre = _optionalText(genre),
       description = _optionalText(description),
       notes = _optionalText(notes),
       coverPath = _optionalText(coverPath),
       createdAt = (createdAt ?? DateTime.now()).toUtc(),
       updatedAt = (updatedAt ?? createdAt ?? DateTime.now()).toUtc() {
    if (id != null && id! <= 0) {
      throw ArgumentError.value(id, 'id', 'Must be positive');
    }
    if (this.title.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Must not be empty');
    }
    if (this.author.isEmpty) {
      throw ArgumentError.value(author, 'author', 'Must not be empty');
    }
    if (totalPages != null && totalPages! <= 0) {
      throw ArgumentError.value(totalPages, 'totalPages', 'Must be positive');
    }
    if (currentPage < 0) {
      throw ArgumentError.value(
        currentPage,
        'currentPage',
        'Cannot be negative',
      );
    }
    if (totalPages == null && currentPage != 0) {
      throw ArgumentError.value(
        currentPage,
        'currentPage',
        'Total pages must be provided before tracking progress',
      );
    }
    if (totalPages != null && currentPage > totalPages!) {
      throw ArgumentError.value(
        currentPage,
        'currentPage',
        'Cannot exceed total pages',
      );
    }
  }

  final int? id;
  final String title;
  final String author;
  final String? genre;
  final String? description;
  final String? notes;
  final String? coverPath;
  final BookStatus status;
  final int? totalPages;
  final int currentPage;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Null means the total page count is unknown.
  double? get progress => totalPages == null ? null : currentPage / totalPages!;

  /// Use an explicit null to clear an optional value such as [totalPages].
  Book copyWith({
    String? title,
    String? author,
    Object? genre = _unchanged,
    Object? description = _unchanged,
    Object? notes = _unchanged,
    Object? coverPath = _unchanged,
    BookStatus? status,
    Object? totalPages = _unchanged,
    int? currentPage,
    bool? isFavorite,
  }) => Book(
    id: id,
    title: title ?? this.title,
    author: author ?? this.author,
    genre: identical(genre, _unchanged) ? this.genre : genre as String?,
    description: identical(description, _unchanged)
        ? this.description
        : description as String?,
    notes: identical(notes, _unchanged) ? this.notes : notes as String?,
    coverPath: identical(coverPath, _unchanged)
        ? this.coverPath
        : coverPath as String?,
    status: status ?? this.status,
    totalPages: identical(totalPages, _unchanged)
        ? this.totalPages
        : totalPages as int?,
    currentPage: currentPage ?? this.currentPage,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  Map<String, Object?> toDatabaseMap() => {
    if (id != null) 'id': id,
    'title': title,
    'author': author,
    'genre': genre,
    'description': description,
    'notes': notes,
    'cover_path': coverPath,
    'status': status.storageValue,
    'total_pages': totalPages,
    'current_page': currentPage,
    'is_favorite': isFavorite ? 1 : 0,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
  };

  factory Book.fromDatabaseMap(Map<String, Object?> row) => Book(
    id: row['id'] as int,
    title: row['title'] as String,
    author: row['author'] as String,
    genre: row['genre'] as String?,
    description: row['description'] as String?,
    notes: row['notes'] as String?,
    coverPath: row['cover_path'] as String?,
    status: BookStatus.fromStorageValue(row['status'] as String),
    totalPages: row['total_pages'] as int?,
    currentPage: row['current_page'] as int,
    isFavorite: (row['is_favorite'] as int) == 1,
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      row['created_at'] as int,
      isUtc: true,
    ),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(
      row['updated_at'] as int,
      isUtc: true,
    ),
  );

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
