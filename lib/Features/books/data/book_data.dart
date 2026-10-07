import 'package:dio/dio.dart';
import 'package:sell_your_books/Features/books/data/book_dto.dart';
import 'package:sell_your_books/Features/global/data/connection_to_api.dart';
import 'package:sell_your_books/Features/global/data/responce_api_with_status_code.dart';

class ClsBookData {

  static Future<int> addNewBook({required ClsBookDTO addBookDTO}) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.post(
        'Books/AddNewBook',
        data: addBookDTO.toAddNewBookMap(),
      );

      return response.statusCode ?? 0;
    } on DioException catch (e) {
      return e.response?.statusCode ?? 0;
    }
  }

  static Future<int> updateBook({required ClsBookDTO updateBookDTO}) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.put(
        'Books/UpdateBookByID',
        queryParameters: {'bookID': updateBookDTO.bookId},
        data: updateBookDTO.toUpdateBookMap(),
      );

      return response.statusCode ?? 0;
    } on DioException catch (e) {
      return e.response?.statusCode ?? 0;
    }
  }

  static Future<ClsApiResponse<ClsPaginatedBooksDTO>> getAllBooks({
    required int pageNumber,
    required int pageSize,
    required int personID,
  }) async {
    try {
      final response = await ClsConnectionToAPI.accessDio.get(
        'Books/GetAllBooksByPersonID',
        queryParameters: {'personID': personID, 'pageNumber': pageNumber, 'pageSize': pageSize},
      );

      return ClsApiResponse(
        statusCode: response.statusCode ?? 0,
        data: ClsPaginatedBooksDTO.fromMap(response.data),
      );
    } on DioException catch (e) {
      return ClsApiResponse(statusCode: e.response?.statusCode ?? 0);
    }
  }
  

  static Future<ClsApiResponse<ClsBookDTO>> getBookByID({required int bookID}) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.get(
        'Books/FindBookById',
        queryParameters: {'bookId': bookID},
      );

      return ClsApiResponse(
        statusCode: response.statusCode ?? 0,
        data: ClsBookDTO.fromMap(response.data),
      );
    } on DioException catch (e) {
      return ClsApiResponse(statusCode: e.response?.statusCode ?? 0);
    }
  }


  static Future<int> deleteBookByID({required int bookID}) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.delete(
        'Books/DeleteBookByID',
        queryParameters: {'bookID': bookID},
      );

      return response.statusCode ?? 0;
    } on DioException catch (e) {
      return e.response?.statusCode ?? 0;
    }
  }
  
}
