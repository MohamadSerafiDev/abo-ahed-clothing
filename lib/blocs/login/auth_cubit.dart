import 'dart:developer';
import 'package:abo_abed_clothing/blocs/login/auth_state.dart';
import 'package:abo_abed_clothing/core/apis/user/user_api.dart';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserApi _userApi;
  final StorageService _storageService;

  AuthCubit(this._userApi, this._storageService) : super(AuthInitial());

  /// Login user
  void login({required String phone, required String password}) async {
    emit(AuthLoading());
    final result = await _userApi.login(phone: phone, password: password);

    if (result.containsKey('error')) {
      emit(AuthFailure(result['error']));
      return;
    }
    log(result.toString());

    try {
      final String token = result['token'];
      final String role = result['role'];

      await _storageService.saveToken(token, role);

      emit(AuthSuccess(role: role, message: 'Login successful'));
    } catch (e) {
      emit(AuthFailure('unexpected error : ${e.toString()}'));
    }
  }

  /// Sign up new user
  void signup({
    required String name,
    required String phone,
    required String address,
    required String password,
    String role = 'Customer', // Default role
  }) async {
    emit(AuthLoading());
    final result = await _userApi.signup({
      'name': name,
      'phone': phone,
      'address': address,
      'password': password,
      'role': role,
    });

    if (result.containsKey('error')) {
      emit(AuthFailure(result['error']));
      return;
    }

    try {
      emit(AuthSuccess(message: 'Account created successfully'));
    } catch (e) {
      emit(AuthFailure('unexpected error : ${e.toString()}'));
    }
  }

  /// Logout user
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _storageService.logout();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure('Failed to logout: ${e.toString()}'));
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _storageService.isLoggedIn();
  }

  /// Get current user role
  String getUserRole() {
    return _storageService.getRole();
  }

  /// Reset state to initial
  void reset() {
    emit(AuthInitial());
  }
}
