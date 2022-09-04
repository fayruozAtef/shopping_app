import 'package:shoping/models/login_models.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}

class RegisterSucessState extends RegisterStates{
  final LoginModel loginUser;
  RegisterSucessState(this.loginUser);
}

class RegisterErrorState extends RegisterStates{
  final String error;
  RegisterErrorState(this.error);
}

class ChangeRegisterPasswordVisibilityState extends RegisterStates{}