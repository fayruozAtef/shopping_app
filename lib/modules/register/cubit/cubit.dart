import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/modules/register/cubit/states.dart';

import '../../../models/login_models.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates>{

  RegisterCubit():super(RegisterInitialState());

  static RegisterCubit get(context) =>BlocProvider.of(context);

  IconData suffixIcon = Icons.visibility_outlined;
  bool hidePassword=true;

  LoginModel? loginModel;

  void userRegister({
  required String email,
    required String password,
    required String name,
    required String phone,
}){
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'email':'$email',
        'name':'$name',
        'phone':'$phone',
        'password':'$password'
      },
    ).then((value) => {
      loginModel= LoginModel.fromJson(value.data),
      emit(RegisterSucessState(loginModel!)),
    }).catchError((onError){
      print("Error --> "+onError.toString());
      emit(RegisterErrorState(onError.toString()));
    });
  }

  void changePasswordVisibility(){
    hidePassword = !hidePassword;
    suffixIcon= hidePassword? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangeRegisterPasswordVisibilityState());
  }
}