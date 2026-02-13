import 'package:abo_abed_clothing/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String? role;
  final String message;

  AuthSuccess({this.role, required this.message});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

class AuthLoggedOut extends AuthState {}

class AuthUserLoaded extends AuthState {
  final UserModel user;

  AuthUserLoaded(this.user);
}
