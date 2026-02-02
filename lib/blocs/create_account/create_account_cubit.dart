import 'package:abo_abed_clothing/core/apis/user_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final result = await _userApi.signup({
      'name': name,
      'phone': phone,
      'address': address,
      'password': password,
      'role': 'Customer',
    });

    if (result.containsKey('error')) {
      emit(CreateAccountFailure(result['error']));
      return;
    }

    try {
      emit(CreateAccountSuccess());
    } catch (e) {
      emit(CreateAccountFailure('unexpected error : ${e.toString()}'));
    }
  }
}
