class ClsSignInResponseDTO {
  final int personID;
  final String email;
  final String role;
  final String accessToken;
  final String refreshToken;

  ClsSignInResponseDTO({
    required this.personID,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
  });

  factory ClsSignInResponseDTO.fromMap(Map<String, dynamic> map) {
    return ClsSignInResponseDTO(
      personID: map['personID'],
      email: map['email'],
      role: map['role'],
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
    );
  }
}

class ClsSignInDTO {
  final String email;
  final String password;

  ClsSignInDTO({required this.email, required this.password});

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}

class ClsRefreshDTO {
  final String email;
  final String refreshToken;
  // final String accessToken = '';

  ClsRefreshDTO({required this.email, required this.refreshToken});


  Map<String, dynamic> toMap() {
    return {'refreshToken': refreshToken, 'email': email};
  }

}

class ClsSignUPSellerDTO {
  final String fullName;
  final String email;
  final String password;
  final String? phone;
  final String? addressPerson;
  final String storeName;
  final String? logoStore;

  ClsSignUPSellerDTO({
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
    this.addressPerson,
    required this.storeName,
    this.logoStore,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'addressPerson': addressPerson,
      'storeName': storeName,
      'logoStore': logoStore,
    };
  }
}
