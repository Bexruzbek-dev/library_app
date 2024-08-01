import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:library_app/data/models/book.dart';
import 'package:library_app/data/repositories/book_repository.dart';
import 'package:library_app/services/permission_service.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc({required this.bookRepository})
      : super(BookState(
          status: BookStatus.initial,
          books: [],
        )) {
    on<GetBooks>(_onGetBooks);
    on<DownloadBook>(_onDownloadBook);
    on<OpenBook>(_onOpenBook);
  }

  final BookRepository bookRepository;

  void _onGetBooks(event, emit) async {
    emit(state.copyWith(status: BookStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 1));
      final books = bookRepository.getBooks();

      for (Book book in books) {
        final fullPath = await _getSavePath(book);
        if (_checkFileExists(fullPath)) {
          book.isDownloaded = true;
          book.saveUrl = fullPath;
          book.progress = 1;
        }
      }

      emit(state.copyWith(
        status: BookStatus.loaded,
        books: books,
       
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onDownloadBook(DownloadBook event, emit) async {
    final index = state.books!.indexWhere((book) {
      return book.id == event.book.id;
    });
    state.books![index].isLoading = true;
    emit(state.copyWith(books: state.books));

    try {
      if (await PermissionService.requestStoragePermission()) {
        final dio = Dio();

        final fullPath = await _getSavePath(event.book);
        final response = await dio.download(
          event.book.url,
          fullPath,
          onReceiveProgress: (count, total) {
            // count - qancha qismi yuklandi
            // total - jami hajmi
            final progress = count / total;
            state.books![index].progress = progress;
            emit(state.copyWith(
              books: state.books,
            ));
          },
        );

        print(response);

        state.books![index].isDownloaded = true;
        state.books![index].isLoading = false;
        state.books![index].saveUrl = fullPath;

        emit(state.copyWith(
          books: state.books,
        ));
      } else {
        emit(
          state.copyWith(
            status: BookStatus.error,
            errorMessage: "Permission not granted",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: BookStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

 

  Future<void> _onOpenBook(OpenBook event, emit) async {
    await OpenFilex.open(event.filePath);
  }

  Future<String> _getSavePath(Book book) async {
    Directory? savePath = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      savePath = Directory("/storage/emulated/0/download");
    }

    final bookName = book.title;
    final bookFormat = book.url.split('.').last;
    final fullPath = "${savePath!.path}/$bookName.$bookFormat";

    return fullPath;
  }

  bool _checkFileExists(String fullPath) {
    final file = File(fullPath);

    return file.existsSync();
  }
}
