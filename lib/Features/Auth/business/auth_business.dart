import 'package:sell_your_books/Features/Auth/data/auth_data.dart';
import 'package:sell_your_books/Features/Auth/data/auth_dtos.dart';
import 'package:sell_your_books/Features/global/data/responce_api_with_status_code.dart';

class ClsAuthBusiness {
  
  static Future<ClsApiResponse<ClsSignInResponseDTO>> signIn(
    ClsSignInDTO signInDTO,
  ) async {
    return await ClsAuthData.signIn(signInDTO);
  }

  static Future<int> signUpSeller(ClsSignUPSellerDTO signUpDTO) async {
    return await ClsAuthData.signUpSeller(signUpDTO);
  }

  static Future<int> logout() async {
    return await ClsAuthData.logout();
  }
}
