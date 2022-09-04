import 'package:shoping/models/login_models.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates{}

class LoginLoadingState extends LoginStates{}

class LoginSucessState extends LoginStates{
  final LoginModel loginUser;
  LoginSucessState(this.loginUser);
}

class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}

class ChangePasswordVisibilityState extends LoginStates{}