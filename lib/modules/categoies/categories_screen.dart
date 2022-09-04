import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/layout/shop_app/cubit/shop_cubit.dart';
import 'package:shoping/layout/shop_app/cubit/states.dart';

import '../../shared/component/components.dart';
import '../category_details/category_details_screen.dart';

class CategoriesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state){

      },
      builder: (context,state){
        var cubit =ShopCubit.get(context);
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context,index)=>InkWell(
            child: buildCategoryItem(
              image: cubit.categoriesModel!.data!.data[index].image ?? '',
              name: cubit.categoriesModel!.data!.data[index].name ?? '',
            ),
            onTap: (){
              ShopCubit.get(context).getCategoryProducts(cubit.categoriesModel!.data!.data[index].id.toString());
              navigateTo(context, CategoryDetailsScreen(categoryDate: cubit.categoriesModel!.data!.data[index]));
            },
          ),
          separatorBuilder: (context,index)=>myDividor(),
          itemCount: cubit.categoriesModel!.data!.data.length,
        );
      },

    );
  }

  Widget buildCategoryItem({required String image, required String name})=>Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(
          image: NetworkImage('$image'),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 20.0,),
        Text(
          '$name',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Icon(Icons.arrow_forward_ios_outlined),
      ],
    ),
  );
}
