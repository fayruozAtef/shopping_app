import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/shared/cubit/states.dart';
import '../network/local/cach_helper.dart';

//import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  bool isDark=false;

  void changeMode({bool? sharedMode}){
    if(sharedMode!= null) {
      isDark = sharedMode;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CashHelper.putData(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }

  }

}