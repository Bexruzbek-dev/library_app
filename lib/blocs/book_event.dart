part of 'book_bloc.dart';

sealed class BookEvent {}

final class GetBooks extends BookEvent {}

final class DownloadBook extends BookEvent {
  final Book book;

  DownloadBook({
    required this.book,
  });
}

final class OpenBook extends BookEvent {
  final String filePath;

  OpenBook({required this.filePath});
}

