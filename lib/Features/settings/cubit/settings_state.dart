part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

class Loading extends SettingsState {}

class SuccessUpdatedSeller extends SettingsState {}

class SuccessChangedPassword extends SettingsState {}

class SuccessDeletedSeller extends SettingsState {}

class BadRequest extends SettingsState {}

class Unauthorized extends SettingsState {}

class Forbidden extends SettingsState {}

class NotFound extends SettingsState {}

class Conflict extends SettingsState {}

class TooManyRequests extends SettingsState {}

class ServerError extends SettingsState {}

class Failure extends SettingsState {
  final int statusCode;
  Failure(this.statusCode);
}

class GetSellerByPersonIDSuccess extends SettingsState {
  final ClsSettingsDto result;
  GetSellerByPersonIDSuccess(this.result);
}
