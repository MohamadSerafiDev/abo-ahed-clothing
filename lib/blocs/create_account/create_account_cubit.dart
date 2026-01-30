import 'package:abo_abed_clothing/core/apis/user_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final UserApi _userApi;

  CreateAccountCubit(this._userApi) : super(CreateAccountInitial());

  void createAccount({
    required String name,
    required String phone,
    required String address,
    required String password,
  }) async {
    emit(CreateAccountLoading());
    try {
      final result = await _userApi.signup({
        'name': name,
        'phone': phone,
        'address': address,
        'password': password,
      });

      if (result['status'] == 'success') {
        emit(CreateAccountSuccess());
      } else {
        emit(CreateAccountFailure(result['message'] ?? 'signup_failed'.tr));
      }
    } catch (e) {
      emit(CreateAccountFailure(e.toString()));
    }
  }
}
