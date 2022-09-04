import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/layout/shop_app/cubit/shop_cubit.dart';
import 'package:shoping/layout/shop_app/cubit/states.dart';
import 'package:shoping/shared/component/components.dart';
import 'package:shoping/shared/component/constants.dart';

class SettingsScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){
        if (state is ShopSucessUpdateProfileDataState) {
          showToast(
              messege: 'Updated data Sucessfully', state: ToastStates.SUCCESS);
        }
        else if(state is ShopErrorUpdateProfileDataState){
          showToast(messege: 'Unable to update the data. \nTry again later.', state: ToastStates.ERROR);
        }
      },
      builder: (context,state) {

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) {
            var model =ShopCubit.get(context).userModel;
            nameController.text=model!.data!.name ?? '';
            emailController.text=model.data!.email ?? '';
            phoneController.text=model.data!.phone! ;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if(state is ShopLoadingUpdateProfileDataState)
                        LinearProgressIndicator(),
                      SizedBox(height: 20.0,),
                      defaultTextFormField(
                          controler: nameController,
                          input: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'name must not be empty';
                            }
                          },
                          lable: 'Name',
                          icon: Icons.person),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                        controler: emailController,
                        input: TextInputType.emailAddress,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'email must not be empty';
                          }
                          else if (!value.contains('@')) {
                            return 'email is not correct';
                          }
                          return null;
                        },
                        lable: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                        controler: phoneController,
                        input: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'phone must not be empty';
                          }
                        },
                        lable: 'Phone',
                        icon: Icons.email_outlined,
                      ),
                      SizedBox(height: 20,),
                      defaultButton(
                        function: (){
                          if(formKey.currentState!.validate()){
                            ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                        text: 'Update',
                      ),
                      SizedBox(height: 20,),
                      defaultButton(
                        function: (){
                          signOut(context);
                        },
                        text: 'LOGOUT',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },

          fallback: (context) =>
              Center(
                child: CircularProgressIndicator(),
              ),
        );
      });
  }
}
