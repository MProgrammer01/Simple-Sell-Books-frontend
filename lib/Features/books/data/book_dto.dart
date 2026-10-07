class ClsBookDTO {
  int bookId = 0;
  int personId = 0;
  final int categoryId;
  final String title;
  final String author;
  final String? bookDescription;
  final double price;
  final int stock;
  final int conditionId;
  final String? coverImg;
  final int statusId;
  final DateTime createdAt = DateTime.now();
  final DateTime updatedAt = DateTime.now();

  //Retrive
  ClsBookDTO.retriveData({
    required this.bookId,
    required this.categoryId,
    required this.title,
    required this.author,
    this.bookDescription,
    required this.price,
    required this.stock,
    required this.conditionId,
    this.coverImg,
    required this.statusId,
  });

  //Add New
  ClsBookDTO.addNewBook({
    required this.personId,
    required this.categoryId,
    required this.title,
    required this.author,
    this.bookDescription,
    required this.price,
    required this.stock,
    required this.conditionId,
    this.coverImg,
    required this.statusId,
  });

  Map<String, dynamic> toAddNewBookMap() {
    return {
      'personId': personId,
      'categoryId': categoryId,
      'title': title,
      'author': author,
      'bookDescription': bookDescription,
      'price': price,
      'stock': stock,
      'conditionId': conditionId,
      'coverImg': coverImg,
      'statusId': statusId,
    };
  }

  //update
  ClsBookDTO.updateBook({
    required this.bookId,
    required this.categoryId,
    required this.title,
    required this.author,
    this.bookDescription,
    required this.price,
    required this.stock,
    required this.conditionId,
    this.coverImg,
    required this.statusId,
  });

  Map<String, dynamic> toUpdateBookMap() {
    return {
      // 'bookId': bookId,
      'categoryId': categoryId,
      'title': title,
      'author': author,
      'bookDescription': bookDescription,
      'price': price,
      'stock': stock,
      'conditionId': conditionId,
      'coverImg': coverImg,
      'statusId': statusId,
    };
  }

  factory ClsBookDTO.fromMap(Map<String, dynamic> map) {
    return ClsBookDTO.retriveData(
      bookId: map['bookId'],
      categoryId: map['categoryId'],
      title: map['title'],
      author: map['author'],
      bookDescription: map['bookDescription'],
      price: map['price'],
      stock: map['stock'],
      conditionId: map['conditionId'],
      coverImg: map['coverImg'],
      statusId: map['statusId'],
    );
  }
}

class ClsPaginatedBooksDTO {
  final List<ClsBookDTO> books;
  final int totalCount;

  ClsPaginatedBooksDTO({required this.books, required this.totalCount});

  int get totalPages => totalCount;

  factory ClsPaginatedBooksDTO.fromMap(Map<String, dynamic> map) {
    return ClsPaginatedBooksDTO(
      books: (map['books'] as List)
          .map((book) => ClsBookDTO.fromMap(book))
          .toList(),

      totalCount: map['totalCount'],
    );
  }
}
