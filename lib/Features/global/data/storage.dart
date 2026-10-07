class ClsStorage {
  static String? _accessToken;
  static String? _refreshToken;
  static String? _email;
  static int? _personID;

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static String? get email => _email;
  static int? get personID => _personID;

  static void saveInfos({
    required String accessToken,
    required String refreshToken,
    required String email,
    required int personID,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _email = email;
    _personID = personID;
  }

  static void updateTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  static void clearData() {
    _accessToken = null;
    _refreshToken = null;
    _email = null;
    _personID = null;
  }
}
