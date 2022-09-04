import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/layout/shop_app/cubit/states.dart';
import 'package:shoping/models/favorites_model.dart';
import '../../layout/shop_app/cubit/shop_cubit.dart';
import '../../shared/component/components.dart';
import '../../shared/styles/colors.dart';

class FavouritesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){

      },
      builder: (context, state)=>ConditionalBuilder(
          condition: state is! ShopLoadingFavoriteState,
          builder: (index)=>ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index)=>buildFavoritItem(ShopCubit.get(context).favoriteModel!.data!.data[index],context),
            separatorBuilder: (context,index)=>myDividor(),
            itemCount: ShopCubit.get(context).favoriteModel!.data!.data.length,
          ),
          fallback: (index)=>Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  Widget buildFavoritItem(FavoritesData model,context)=> Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.product!.image ?? ''),
                width: 120.0,
                height: 120.0,
                //fit: BoxFit.cover,
              ),
              //if (model.discount != 0)
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
          const SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.product!.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.6,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Price: ${model.product!.price}',
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
                    if (model.product!.discount != 0)
                      Text(
                        '${model.product!.oldPrice}',
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
                        ShopCubit.get(context).changeFavorites(productId: model.product!.id);
                      },
                      icon: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: (ShopCubit.get(context).favourites[model.product!.id] ?? false) ? defaultColor : Colors.grey,
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
    ),
  );
}
