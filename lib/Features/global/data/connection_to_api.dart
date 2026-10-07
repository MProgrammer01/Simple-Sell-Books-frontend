import 'package:dio/dio.dart';
import 'package:sell_your_books/Features/Auth/data/auth_dtos.dart';
import 'package:sell_your_books/Features/global/data/storage.dart';

class ClsConnectionToAPI {
  static final String _baseUrl = 'https://localhost:7282/api/';
  static final Dio accessDio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static void initialize() {
    accessDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final accessToken = ClsStorage.accessToken;

          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          handler.next(options);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode != 401) {
            handler.next(error);
            return;
          }

          final refreshToken = ClsStorage.refreshToken;
          final email = ClsStorage.email;

          if (refreshToken == null ||
              refreshToken.isEmpty ||
              email == null ||
              email.isEmpty) {
            ClsStorage.clearData();

            handler.next(error);
            return;
          }

          ClsRefreshDTO refreshDTO = ClsRefreshDTO(
            email: email,
            refreshToken: refreshToken,
          );

          try {
            final response = await _refreshDio.post(
              'Auth/refresh',
              data: refreshDTO.toMap(),
            );

            final newAccessToken = response.data['accessToken'];

            final newRefreshToken = response.data['refreshToken'];

            ClsStorage.updateTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            final requestOptions = error.requestOptions;

            requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await accessDio.fetch(requestOptions);

            handler.resolve(retryResponse);
          } on DioException catch (_) {
            ClsStorage.clearData();

            handler.next(error);
          }
        },
      ),
    );
  }
}
