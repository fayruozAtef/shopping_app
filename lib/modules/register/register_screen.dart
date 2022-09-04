import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/modules/register/cubit/cubit.dart';

import '../../layout/shop_app/shop_layout.dart';
import '../../shared/component/components.dart';
import '../../shared/component/constants.dart';
import '../../shared/network/local/cach_helper.dart';
import '../login/cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  var emailController =TextEditingController();

  var passwordController =TextEditingController();

  var nameController =TextEditingController();

  var phoneController =TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context)=>RegisterCubit(),
        child: BlocConsumer<RegisterCubit,RegisterStates>(
          listener:(context , state){
            if(state is RegisterSucessState){
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
          builder: (context , state){
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Make a new account to browse our product',
                          style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        //Name
                        defaultTextFormField(
                          controler: nameController,
                          input: TextInputType.name,
                          validate: (value){
                            if(value!.isEmpty){
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          lable: 'User Name',
                          icon: Icons.person,
                        ),

                        SizedBox(height: 20,),
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
                          isPassword:RegisterCubit.get(context).hidePassword,
                          sufixIcon: RegisterCubit.get(context).suffixIcon,
                          suffixWork: (){
                            RegisterCubit.get(context).changePasswordVisibility();
                          },

                        ),
                        const SizedBox(height: 20,),
                        //phone
                        defaultTextFormField(
                            controler: phoneController,
                            input: TextInputType.phone,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'enter your phone number';
                              }
                              return null;

                            },
                            lable: 'Phone number',
                            icon: Icons.phone_android_outlined
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //ButtonLogin
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context)=> defaultButton(
                            function:(){
                              if(formKey.currentState!.validate()){
                                RegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text
                                );
                              }
                            },
                            text: 'Register',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>Center(child: CircularProgressIndicator(),),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
