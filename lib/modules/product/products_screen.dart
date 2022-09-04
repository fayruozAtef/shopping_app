import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/layout/shop_app/cubit/shop_cubit.dart';
import 'package:shoping/layout/shop_app/cubit/states.dart';
import 'package:shoping/models/categories_model.dart';
import 'package:shoping/models/home_model.dart';
import 'package:shoping/modules/category_details/category_details_screen.dart';
import 'package:shoping/shared/component/components.dart';

import '../../shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {

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
          return ConditionalBuilder(
              condition: cubit.homeModel != null && cubit.categoriesModel != null,
              builder: (context){
                return productBuilder(cubit.homeModel!,cubit.categoriesModel!,context);
              },
              fallback: (context){
                return Center(child: CircularProgressIndicator());
                },
          );
        },
    );
  }

  Widget productBuilder(HomeModel? model ,CategoriesModel categoriesModel,context)=> SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            items: model!.data!.banners.map((e) =>Image(
              image: NetworkImage('${e.image}'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),).toList(),
            options: CarouselOptions(
              height: 250.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: true,
              reverse: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
            ),
        ),
        const SizedBox(height: 10.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w600),
              ),
              Container( //Error when removing the container
                height: 110,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder:(context, index) {
                      return InkWell(
                        child: buildCategoryItem(
                          name: categoriesModel.data!.data[index].name ?? '',
                          image: categoriesModel.data!.data[index].image ?? '',
                        ),
                        onTap: (){
                          ShopCubit.get(context).getCategoryProducts(categoriesModel.data!.data[index].id.toString());
                          navigateTo(context, CategoryDetailsScreen(categoryDate: categoriesModel.data!.data[index]));
                        },
                      );
                      },
                    separatorBuilder: (context, index)=>SizedBox(width: 10.0,),
                    itemCount: categoriesModel.data!.data.length,
                ),
              ),
              const SizedBox(height: 10.0,),
              Text(
                'New Products',
                style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        Container(
          color: Colors.grey[300],
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            childAspectRatio: 1/1.6,
            crossAxisCount: 2,
            children: List.generate(
                model.data!.products.length,
                    (index) => buildGridProduct(model.data!.products[index],context )),
          ),
        ),
      ],
    ),
  );

  Widget buildGridProduct(ProductsModelObject model,context) {
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
                      'Price: ${model.price.round()}',
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
                        '${model.oldPrice.round()}',
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
                        ShopCubit.get(context).changeFavorites(productId: model.id);
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

  Widget buildCategoryItem({required String image, required String name})=>Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage('$image'),
        width: 100,
        height: 100,
      ),
      Container(
        color: Colors.black.withOpacity(.8),
        width: 100,
        child: Text(
          '$name',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
