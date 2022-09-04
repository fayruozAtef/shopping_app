import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoping/layout/shop_app/shop_layout.dart';
import 'package:shoping/modules/login/cubit/cubit.dart';
import 'package:shoping/modules/register/register_screen.dart';
import 'package:shoping/shared/component/components.dart';
import 'package:shoping/shared/component/constants.dart';

import '../../shared/network/local/cach_helper.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {

  var emailController =TextEditingController();

  var passwordController =TextEditingController();

  var formKey=GlobalKey<FormState>();

  bool passwordHidden=true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>LoginCubit(),
      child: BlocConsumer <LoginCubit,LoginStates>(
        listener: (context,state){
          if(state is LoginSucessState){
            if(state.loginUser.status!){
              CashHelper.putData(
                key: 'token',
                value: state.loginUser.data!.token,
              ).then((value) {
                navigateAndDelete(context, ShopeHomeLayout());
                TOKEN =state.loginUser.data!.token;
                print(state.loginUser.data!.token);
              });
            }else{
              showToast(
                messege: state.loginUser.message,
                state: ToastStates.ERROR,
              );
              print(state.loginUser.message);
            }
          }
        },
        builder: (context,state){
          return  Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'login now to browse our product',
                          style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        //Email
                        defaultTextFormField(
                            controler: emailController,
                            input: TextInputType.emailAddress,
                            validate: (value){
                              if(value!.isEmpty){
                                  return 'enter your email';
                              }
                              else if(!value.contains('@')){
                                return 'invalid email adderss';
                              }
                              else {
                                return null;
                              }
                            },
                            lable: 'Email address',
                            icon: Icons.email_outlined
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        //Paswword

                        defaultTextFormField(
                            controler: passwordController,
                            input: TextInputType.visiblePassword,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'Enter password';
                              }
                              return null;
                            },
                            lable: 'Password',
                            icon: Icons.lock_outline,
                            isPassword:LoginCubit.get(context).hidePassword,
                            sufixIcon: LoginCubit.get(context).suffixIcon,
                            suffixWork: (){
                              LoginCubit.get(context).changePasswordVisibility();

                            },
                            onSubmitted: (value){
                              if(formKey.currentState!.validate()){
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //ButtonLogin
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context)=> defaultButton(
                            function:(){
                              if(formKey.currentState!.validate()){
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'LOGIN',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "Don't have an account?",
                            ),
                            deafultTextButtom(
                              text: 'Register Now',
                              function: (){
                                navigateTo(context, RegisterScreen());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
