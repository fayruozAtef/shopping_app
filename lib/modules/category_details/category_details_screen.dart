import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/models/categories_model.dart';

import '../../layout/shop_app/cubit/shop_cubit.dart';
import '../../layout/shop_app/cubit/states.dart';
import '../../models/category_details_model.dart';
import '../../shared/component/components.dart';
import '../../shared/styles/colors.dart';

class CategoryDetailsScreen extends StatelessWidget {
  DataModel categoryDate;

  CategoryDetailsScreen({Key? key, required this.categoryDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state){
        if(state is ShopSuccessChangeFavoriteState){
          // هنا لو شغال من غير ما يسجل دخول و يجى يدوس مفضل هيخليه يسجل الأول
          if(!state.model.status){
            showToast(
                messege: state.model.message,
                state: ToastStates.ERROR
            );
          }
        }

      },
      builder: (context, state){
        var  cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(title: Text(categoryDate.name!),),
          body: ConditionalBuilder(
            condition: cubit.categoryDetails !=null && cubit.categoryDetails!.data!.products !=null ,
            builder: (context)=>GridView.count(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 3.0,
              childAspectRatio: 1/1.6,
              crossAxisCount: 2,
              children: List.generate(
                  cubit.categoryDetails!.data!.products!.length,
                      (index) => buildGridProduct(cubit.categoryDetails!.data!.products![index],context )),
            ),
            fallback: (context){
              return Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  Widget buildGridProduct(Products model,context) {
    //bool favColor = ShopCubit.get(context).favourites[model.id] ?? false;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image ?? ''),
                width: double.infinity,
                height: 200.0,
                //fit: BoxFit.cover,
              ),
              if (model.discount != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Text(
                    'DICOUNT',
                    style: TextStyle(fontSize: 10.0, color: Colors.white),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.6,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Price: ${model.price!.round()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice!.round()}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavorites(productId: model.id!);
                      },
                      icon: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: (ShopCubit.get(context).favourites[model.id] ?? false) ? defaultColor : Colors.grey,
                          child: Icon(
                            Icons.favorite_border_outlined,
                            size: 18.0,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
