import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/layout/shop_app/shop_layout.dart';
import 'package:shoping/modules/login/login_screen.dart';
import 'package:shoping/modules/on_boarding/on-boarding_screen.dart';
import 'package:shoping/shared/block_observer.dart';
import 'package:shoping/shared/component/constants.dart';
import 'package:shoping/shared/cubit/cubit.dart';
import 'package:shoping/shared/cubit/states.dart';
import 'package:shoping/shared/network/local/cach_helper.dart';
import 'package:shoping/shared/network/remote/dio_helper.dart';
import 'package:shoping/shared/styles/themes.dart';

import 'layout/shop_app/cubit/shop_cubit.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();//To be sure that every thing is initialized first before running app
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CashHelper.init();
  bool? isDark=  CashHelper.getBoolData(key: 'isDark') ;
  bool? onBoarding=  CashHelper.getBoolData(key: 'onBoarding') ;
  TOKEN=  CashHelper.getBoolData(key: 'token') ;
  Widget? widget;

  if(onBoarding!=null){
    if(TOKEN!=null){
      widget=ShopeHomeLayout();
    }
    else{
      widget=LoginScreen();
    }
  }
  else{
    widget=OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    widget: widget,
  ));
}

class MyApp extends StatelessWidget {

  final bool? isDark;
  Widget? widget;
  MyApp({this.isDark,this.widget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(BuildContext context)=> ShopCubit()..getHomeData()..getCategoriesData()..getFavoriteData()..getUserData(),),
        BlocProvider(create: (BuildContext context)=>AppCubit()..changeMode(sharedMode: false,)),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state){

        },
        builder: (context, state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark?  ThemeMode.dark:ThemeMode.light,
            home:widget,
          );
        },

      ),
    );
  }
}

