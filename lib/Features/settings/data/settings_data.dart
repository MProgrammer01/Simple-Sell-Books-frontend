import 'package:dio/dio.dart';
import 'package:sell_your_books/Features/global/data/connection_to_api.dart';
import 'package:sell_your_books/Features/global/data/responce_api_with_status_code.dart';
import 'package:sell_your_books/Features/settings/data/settings_dto.dart';

class ClsSettingsData {
  static Future<ClsApiResponse<ClsSettingsDto>> getSellerByPersonID({
    required int personID,
  }) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.get(
        'Sellers/FindSellerByPersonID',
        queryParameters: {'personID': personID},
      );

      return ClsApiResponse(
        statusCode: response.statusCode ?? 0,
        data: ClsSettingsDto.fromMap(response.data),
      );
    } on DioException catch (e) {
      return ClsApiResponse(statusCode: e.response?.statusCode ?? 0);
    }
  }

  static Future<int> updateSeller({
    required ClsSettingsDto updateSellerDTO,
  }) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.put(
        'Sellers/UpdateSellerByID',
        data: updateSellerDTO.toUpdateSellerMap(),
      );

      return response.statusCode ?? 0;
    } on DioException catch (e) {
      return e.response?.statusCode ?? 0;
    }
  }

  static Future<int> changePassword({
    required ClsChangePasswordDTO changePasswordDTO,
  }) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.put(
        'People/UpdatePasswordByPersonID',
        data: changePasswordDTO.toMap(),
      );
      return response.statusCode ?? 0;
    } on DioException catch (e) {
      return e.response?.statusCode ?? 0;
    }
  }

  static Future<int> deleteSellerByPersonID({required int personID}) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.delete(
        'People/DeletePerson',
        queryParameters: {'personID': personID},
      );
      return response.statusCode ?? 0;
    } on DioException catch (e) {
      return e.response?.statusCode ?? 0;
    }
  }
}
