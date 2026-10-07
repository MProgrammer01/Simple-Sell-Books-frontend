import 'package:sell_your_books/Features/global/data/responce_api_with_status_code.dart';
import 'package:sell_your_books/Features/settings/data/settings_data.dart';
import 'package:sell_your_books/Features/settings/data/settings_dto.dart';

class ClsSettingsBusiness {
  static Future<ClsApiResponse<ClsSettingsDto>> getSellerByPersonID({required int personID}) async {
    return await ClsSettingsData.getSellerByPersonID(personID: personID);
  }

  static Future<int> updateSeller({required ClsSettingsDto updateSellerDTO}) async {
    return await ClsSettingsData.updateSeller(updateSellerDTO: updateSellerDTO);
  }

  static Future<int> changePassword({required ClsChangePasswordDTO changePasswordDTO}) async {
    return await ClsSettingsData.changePassword(changePasswordDTO: changePasswordDTO);
  }

  static Future<int> deleteSellerByPersonID({required int personID}) async {
    return await ClsSettingsData.deleteSellerByPersonID(personID: personID);
  }
}