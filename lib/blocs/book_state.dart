part of 'book_bloc.dart';

enum BookStatus {
  loading,
  loaded,
  error,
  initial,
}

final class BookState {
  BookStatus? status;
  List<Book>? books;
  String? errorMessage;

  BookState({
    this.status,
    this.books,
    this.errorMessage,
  });

  BookState copyWith({
    BookStatus? status,
    List<Book>? books,
    String? errorMessage,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? books,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}



// final class LoadingState {}

// final class LoadedState {}

// final class ErrorState {}

// final class InitialState {}
