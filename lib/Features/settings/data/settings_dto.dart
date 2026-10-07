class ClsSettingsDto {
  int personID = 0;
  final String storeName;
  final String? logoStore;
  final String fullName;
  final String email;
  final String? phone;
  final String? addressPerson;
  String role = "";

  ClsSettingsDto.retriveData({
    required this.storeName,
    this.logoStore,
    required this.fullName,
    required this.email,
    this.phone,
    this.addressPerson,
    required this.role,
  });

   factory ClsSettingsDto.fromMap(Map<String, dynamic> map) {
    return ClsSettingsDto.retriveData(
      storeName: map['storeName'],
      logoStore: map['logoStore'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      addressPerson: map['addressPerson'],
      role: map['role'],
    );
  }

  ClsSettingsDto.updateSeller({
    required this.personID,
    required this.storeName,
    this.logoStore,
    required this.fullName,
    required this.email,
    this.phone,
    this.addressPerson,
  });

   Map<String, dynamic> toUpdateSellerMap() {
    return {
      'personID': personID,
      'storeName': storeName,
      'logoStore': logoStore,
      'fullName': fullName,
      'email': email,
      'addressPerson': addressPerson,
      'phone': phone,
    };
  }
}

class ClsChangePasswordDTO{
 final int personID;
  final String oldPassword;
  final String newPassword;

  ClsChangePasswordDTO({
    required this.personID,
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'personID': personID,
      'currentPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}
