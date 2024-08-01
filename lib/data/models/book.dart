class Book {
  int id;
  String title;
  String description;
  String author;
  String imageUrl;
  double rate;
  String url;
  double price;
  bool isLoading;
  bool isDownloaded;
  double progress;
  String saveUrl;

 

  Book(
      {required this.id,
      required this.title,
      required this.description,
      required this.author,
      required this.rate,
      required this.price,
      this.isLoading = false,
      this.isDownloaded = false,
      this.progress = 0,
      this.saveUrl = "",
      required this.imageUrl,
      required this.url});
}
