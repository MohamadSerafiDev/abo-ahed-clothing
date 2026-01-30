import 'package:abo_abed_clothing/core/apis/user_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserApi _userApi;

  LoginCubit(this._userApi) : super(LoginInitial());

  void login({required String phone, required String password}) async {
    emit(LoginLoading());
    try {
      final result = await _userApi.login(phone: phone, password: password);
      if (result['status'] == 'success') {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(result['message'] ?? 'login_failed'.tr));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
