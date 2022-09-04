import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/modules/login/cubit/states.dart';

import '../../../models/login_models.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates>{

  LoginCubit():super(LoginInitialState());

  static LoginCubit get(context) =>BlocProvider.of(context);

  IconData suffixIcon = Icons.visibility_outlined;
  bool hidePassword=true;

  LoginModel? loginModel;

  void userLogin({
  required String email,
    required String password,
}){
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email':'$email',
        'password':'$password'
      },
    ).then((value) => {
      loginModel= LoginModel.fromJson(value.data),
      emit(LoginSucessState(loginModel!)),
    }).catchError((onError){
      print("Error --> "+onError.toString());
      emit(LoginErrorState(onError.toString()));
    });
  }

  void changePasswordVisibility(){
    hidePassword = !hidePassword;
    suffixIcon= hidePassword? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }
}