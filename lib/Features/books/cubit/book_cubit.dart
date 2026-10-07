import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sell_your_books/Features/books/business/book_business.dart';
import 'package:sell_your_books/Features/books/data/book_dto.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookInitial());

  // =========================
  // Add New Book
  // =========================

  Future<void> addNewBook(ClsBookDTO addBookDTO) async {
    emit(Loading());

    final statusCodeResult = await ClsBookBusiness.addNewBook(
      addBookDTO: addBookDTO,
    );

    switch (statusCodeResult) {
      case 201:
        emit(Success("Added"));
        break;

      case 400:
        emit(BadRequest());
        break;

      case 401:
        emit(Unauthorized());
        break;

      case 403:
        emit(Forbidden());
        break;

      case 404:
        emit(NotFound());
        break;

      case 409:
        emit(Conflict());
        break;

      case 429:
        emit(TooManyRequests());
        break;

      case 500:
        emit(ServerError());
        break;

      default:
        emit(Failure(statusCodeResult));
    }
  }

  // =========================
  // Update Book
  // =========================

  Future<void> updateBook(ClsBookDTO updateBookDTO) async {
    emit(Loading());

    final statusCodeResult = await ClsBookBusiness.updateBook(
      updateBookDTO: updateBookDTO,
    );

    switch (statusCodeResult) {
      case 200:
        emit(Success("Updated"));
        break;

      case 400:
        emit(BadRequest());
        break;

      case 401:
        emit(Unauthorized());
        break;

      case 403:
        emit(Forbidden());
        break;

      case 404:
        emit(NotFound());
        break;

      case 409:
        emit(Conflict());
        break;

      case 429:
        emit(TooManyRequests());
        break;

      case 500:
        emit(ServerError());
        break;

      default:
        emit(Failure(statusCodeResult));
    }
  }

  // =========================
  // Get All Books
  // =========================

  Future<void> getAllBooks({required int personID, int pageNumber = 1, int pageSize = 10}) async {
    emit(Loading());

    final result = await ClsBookBusiness.getAllBooks(
      pageNumber: pageNumber,
      pageSize: pageSize,
      personID: personID
    );

    switch (result.statusCode) {
      case 200:
        emit(GetBooksSuccess(result.data!));
        break;

      case 400:
        emit(BadRequest());
        break;

      case 401:
        emit(Unauthorized());
        break;

      case 403:
        emit(Forbidden());
        break;

      case 404:
        emit(NotFound());
        break;

      case 429:
        emit(TooManyRequests());
        break;

      case 500:
        emit(ServerError());
        break;

      default:
        emit(Failure(result.statusCode));
    }
  }

  // =========================
  // Get Book By ID
  // =========================

  Future<void> getBookByID({required int bookID}) async {
    emit(Loading());

    final result = await ClsBookBusiness.getBookByID(bookID: bookID);

    switch (result.statusCode) {
      case 200:
        emit(GetBookByIDSuccess(result.data!));
        break;

      case 400:
        emit(BadRequest());
        break;

      case 401:
        emit(Unauthorized());
        break;

      case 403:
        emit(Forbidden());
        break;

      case 404:
        emit(NotFound());
        break;

      case 429:
        emit(TooManyRequests());
        break;

      case 500:
        emit(ServerError());
        break;

      default:
        emit(Failure(result.statusCode));
    }
  }

  // =========================
  // Delete Book By ID
  // =========================

  Future<void> deleteBookByID({required int bookID}) async {
    emit(Loading());

    final result = await ClsBookBusiness.deleteBookByID(bookID: bookID);

    switch (result) {
      case 200:
        emit(Success("Deleted"));
        break;

      case 400:
        emit(BadRequest());
        break;

      case 401:
        emit(Unauthorized());
        break;

      case 403:
        emit(Forbidden());
        break;

      case 404:
        emit(NotFound());
        break;

      case 429:
        emit(TooManyRequests());
        break;

      case 500:
        emit(ServerError());
        break;

      default:
        emit(Failure(result));
    }
  }
}
