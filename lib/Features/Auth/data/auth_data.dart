import 'package:dio/dio.dart';
import 'package:sell_your_books/Features/Auth/data/auth_dtos.dart';
import 'package:sell_your_books/Features/global/data/connection_to_api.dart';
import 'package:sell_your_books/Features/global/data/responce_api_with_status_code.dart';

class ClsAuthData {
  static Future<ClsApiResponse<ClsSignInResponseDTO>> signIn(
    ClsSignInDTO signInDTO,
  ) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.post(
        'Auth/login',
        data: signInDTO.toMap(),
      );

      return ClsApiResponse(
        statusCode: response.statusCode ?? 0,
        data: ClsSignInResponseDTO.fromMap(response.data),
      );
    } on DioException catch (e) {
      return ClsApiResponse(statusCode: e.response?.statusCode ?? 0);
    }
  }

  static Future<int> signUpSeller(ClsSignUPSellerDTO signUpDTO) async {
    try {
      final Response response = await ClsConnectionToAPI.accessDio.post(
        'Auth/signup',
        data: signUpDTO.toMap(),
      );

      return response.statusCode ?? 0;
    } on DioException catch (e) {
      return e.response?.statusCode ?? 0;
    }
  }
}
