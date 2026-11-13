import 'book.dart';

enum LibrarySort { newest, oldest, titleAsc, titleDesc }

/// Applies the library controls to a snapshot from the local repository.
List<Book> filterLibraryBooks(
  List<Book> books, {
  String query = '',
  BookStatus? status,
  String? genre,
  bool favoritesOnly = false,
  LibrarySort sort = LibrarySort.newest,
}) {
  final term = query.trim().toLowerCase();
  final matching = books.where((book) {
    if (term.isNotEmpty &&
        !book.title.toLowerCase().contains(term) &&
        !book.author.toLowerCase().contains(term)) {
      return false;
    }
    return (status == null || book.status == status) &&
        (genre == null || book.genre == genre) &&
        (!favoritesOnly || book.isFavorite);
  }).toList();

  matching.sort((a, b) {
    final byTitle = a.title.toLowerCase().compareTo(b.title.toLowerCase());
    final byDate = a.createdAt.compareTo(b.createdAt);
    return switch (sort) {
      LibrarySort.newest => -byDate,
      LibrarySort.oldest => byDate,
      LibrarySort.titleAsc => byTitle,
      LibrarySort.titleDesc => -byTitle,
    };
  });
  return matching;
}
