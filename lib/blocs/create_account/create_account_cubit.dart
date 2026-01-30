import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit() : super(CreateAccountInitial());

  void createAccount({
    required String name,
    required String phone,
    required String address,
    required String password,
  }) async {
    // TODO: Implement create account logic
    // emit(CreateAccountLoading());
    // try {
    //   // Call API
    //   emit(CreateAccountSuccess());
    // } catch (e) {
    //   emit(CreateAccountFailure(e.toString()));
    // }
  }
}
