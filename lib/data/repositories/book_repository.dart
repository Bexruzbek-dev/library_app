import 'package:library_app/data/models/book.dart';

class BookRepository {
  final List<Book> _books = [
    Book(
      id: 1,
      title: "Shum bola",
      description: "Kimningdir kitobi",
      author: "G'afur G'ulom",
      rate: 3.9,
      price: 9.99,
      imageUrl: "assets/shumbola.png",
      url: "https://quvonch-books.uz/storage/uploads/files/Shum%20bola%20[@kitoblar_pdf].pdf",
    ),

  ];

  List<Book> getBooks() {
    return [..._books];
  }
}
