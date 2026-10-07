import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sell_your_books/Features/settings/business/settings_business.dart';
import 'package:sell_your_books/Features/settings/data/settings_dto.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  // =========================
  // Get Seller By personID
  // =========================
  Future<void> getSellerByPersonID({required int personID}) async {
    emit(Loading());

    final result = await ClsSettingsBusiness.getSellerByPersonID(personID: personID);

    switch (result.statusCode) {
      case 200:
        emit(GetSellerByPersonIDSuccess(result.data!));
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
        emit(Failure(result.statusCode));
    }
  }

  // =========================
  // Update Seller
  // =========================
  Future<void> updateSeller(ClsSettingsDto updateSellerDTO) async {
    emit(Loading());

    final statusCodeResult = await ClsSettingsBusiness.updateSeller(
      updateSellerDTO: updateSellerDTO,
    );

    switch (statusCodeResult) {
      case 200:
        emit(SuccessUpdatedSeller());
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
  // Update Password Seller
  // =========================
  Future<void> changePassword(ClsChangePasswordDTO changePasswordDTO) async {
    emit(Loading());

    final statusCodeResult = await ClsSettingsBusiness.changePassword(
      changePasswordDTO: changePasswordDTO,
    );

    switch (statusCodeResult) {
      case 200:
        emit(SuccessChangedPassword());
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
        emit(Failure(statusCodeResult));
    }
  }

  // =========================
  // Delete Seller
  // =========================
  Future<void> deleteSellerByPersonID({required int personID}) async {
    emit(Loading());

    final statusCodeResult = await ClsSettingsBusiness.deleteSellerByPersonID(personID: personID);

    switch (statusCodeResult) {
      case 200:
        emit(SuccessDeletedSeller());
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
        emit(Failure(statusCodeResult));
    }
  }
}
