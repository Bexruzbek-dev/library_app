
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/blocs/book_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mening 5"),
      ),
      body: BlocBuilder<BookBloc, BookState>(
        bloc: context.read<BookBloc>()..add(GetBooks()),
        builder: (context, state) {
          if (state.status == BookStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == BookStatus.error) {
            return Center(
              child: Text(state.errorMessage!),
            );
          }

          if (state.books == null || state.books!.isEmpty) {
            return const Center(
              child: Text("Fayllar mavjud emas"),
            );
          }

          final books = state.books!;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (ctx, index) {
              final book = books[index];
              print(book.saveUrl);
              return ListTile(
                title: Text(book.title),
                subtitle: Column(
                  children: [
                    Text(book.url),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: book.progress,
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  
                    book.isLoading
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: () {
                              if (book.isDownloaded) {
                                // open
                                context
                                    .read<BookBloc>()
                                    .add(OpenBook(filePath: book.saveUrl));
                              } else {
                                context
                                    .read<BookBloc>()
                                    .add(DownloadBook(book: book));
                              }
                            },
                            icon: Icon(
                              book.isDownloaded ? Icons.check : Icons.download,
                              size: 40,
                              color: Colors.blue,
                            ),
                          ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
