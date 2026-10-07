part of 'book_cubit.dart';

@immutable
sealed class BookState {}

final class BookInitial extends BookState {}

class Success extends BookState {
  final String message;
  Success(this.message);
}

class Loading extends BookState {}

class BadRequest extends BookState {}

class Unauthorized extends BookState {}

class Forbidden extends BookState {}

class NotFound extends BookState {}

class Conflict extends BookState {}

class TooManyRequests extends BookState {}

class ServerError extends BookState {}

class Failure extends BookState {
  final int statusCode;
  Failure(this.statusCode);
}

class GetBooksSuccess extends BookState {
  final ClsPaginatedBooksDTO result;
  GetBooksSuccess(this.result);
}

class GetBookByIDSuccess extends BookState {
  final ClsBookDTO result;
  GetBookByIDSuccess(this.result);
}
