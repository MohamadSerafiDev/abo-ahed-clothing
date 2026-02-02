import 'dart:developer';

import 'package:abo_abed_clothing/core/apis/user_api.dart';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserApi _userApi;
  final StorageService _storageService;

  LoginCubit(this._userApi, this._storageService) : super(LoginInitial());

  void login({required String phone, required String password}) async {
    emit(LoginLoading());
    final result = await _userApi.login(phone: phone, password: password);

    if (result.containsKey('error')) {
      emit(LoginFailure(result['error']));
      return;
    }
    log(result.toString());

    try {
      final String token = result['token'];
      final String role = result['role'];

      await _storageService.saveToken(token, role);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure('unexpected error : ${e.toString()}'));
    }
  }
}
