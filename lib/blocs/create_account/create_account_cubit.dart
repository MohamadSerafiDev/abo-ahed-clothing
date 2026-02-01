import 'package:abo_abed_clothing/core/apis/user_api.dart';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final UserApi _userApi;
  final StorageService _storageService;

  CreateAccountCubit(this._userApi, this._storageService) : super(CreateAccountInitial());

  void createAccount({
    required String name,
    required String phone,
    required String address,
    required String password,
  }) async {
    emit(CreateAccountLoading());
    final result = await _userApi.signup({
      'name': name,
      'phone': phone,
      'address': address,
      'password': password,
      'role': 'Customer', // Default role for new signups
    });

    if (result.containsKey('error')) {
      emit(CreateAccountFailure(result['error']));
      return;
    }

    try {
      final String token = result['token']; // Assuming 'token' is in the response
      final String role = result['user']['role']; // Assuming 'user.role' is in the response

      await _storageService.saveToken(token, role);

      emit(CreateAccountSuccess());
    } catch (e) {
      emit(CreateAccountFailure('An unexpected error occurred during token/role saving: ${e.toString()}'));
    }
  }
}
