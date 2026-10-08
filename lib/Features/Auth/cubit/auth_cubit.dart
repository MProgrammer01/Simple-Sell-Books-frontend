import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sell_your_books/Features/Auth/business/auth_business.dart';
import 'package:sell_your_books/Features/Auth/data/auth_dtos.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // =========================
  // Sign In
  // =========================

  Future<void> signIn(ClsSignInDTO signInDTO) async {

    emit(AuthLoading());

    final result = await ClsAuthBusiness.signIn(signInDTO);

    switch (result.statusCode) {
      case 200:
        emit(SignInSuccess(result.data!));
        break;

      case 401:
        emit(SignInInvalidCredentials());
        break;

      case 429:
        emit(SignInTooManyRequests());
        break;
      
      // case 500:
      //   emit(SignInInternalServerError());
      //   break;

      default:
        emit(SignInFailure(result.statusCode));
    }
  }


  // =========================
  // Sign Up Seller
  // =========================

  Future<void> signUpSeller(
    ClsSignUPSellerDTO signUpDTO,
  ) async {
    emit(AuthLoading());

    final result = await ClsAuthBusiness.signUpSeller(signUpDTO);

    switch (result) {
      case 201:
        emit(SignUpSuccess());
        break;

      case 409:
        emit(SignUpEmailAlreadyExists());
        break;

      case 429:
        emit(SignUpTooManyRequests());
        break;

        // case 500:
        // emit(SignUpInternalServerError());
        // break;

      default:
        emit(SignUpFailure(result));
    }
  }

  // =========================
  // Logout Seller
  // =========================
  Future<void> logout() async {
    emit(AuthLoading());

    final result = await ClsAuthBusiness.logout();

    switch (result) {
      case 200:
        emit(LogoutSuccess());
        break;

      case 400:
        emit(LogoutBadRequest());
        break;

      case 429:
        emit(LogoutTooManyRequests());
        break;
      
      case 500:
        emit(LogoutInternalServerError());
        break;

      default:
        emit(LogoutFailure(result));
    }
  }
}
