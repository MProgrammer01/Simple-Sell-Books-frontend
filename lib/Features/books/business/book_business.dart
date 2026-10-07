import 'package:sell_your_books/Features/books/data/book_data.dart';
import 'package:sell_your_books/Features/books/data/book_dto.dart';
import 'package:sell_your_books/Features/global/data/responce_api_with_status_code.dart';

class ClsBookBusiness {
  static Future<int> addNewBook({required ClsBookDTO addBookDTO}) async {
    return await ClsBookData.addNewBook(addBookDTO: addBookDTO);
  }

  static Future<int> updateBook({required ClsBookDTO updateBookDTO}) async {
    return await ClsBookData.updateBook(updateBookDTO: updateBookDTO);
  }

  static Future<ClsApiResponse<ClsPaginatedBooksDTO>> getAllBooks({
    required int pageNumber,
    required int pageSize,
    required int personID,
  }) async {
    return await ClsBookData.getAllBooks(
      pageNumber: pageNumber,
      pageSize: pageSize,
      personID: personID
    );
  }

  static Future<ClsApiResponse<ClsBookDTO>> getBookByID({
    required int bookID,
  }) async {
    return await ClsBookData.getBookByID(
      bookID: bookID
    );
  }

  static Future<int> deleteBookByID({
    required int bookID,
  }) async {
    return await ClsBookData.deleteBookByID(
      bookID: bookID
    );
  }
}
