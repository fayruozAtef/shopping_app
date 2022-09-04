import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/layout/shop_app/cubit/shop_cubit.dart';
import 'package:shoping/layout/shop_app/cubit/states.dart';
import 'package:shoping/shared/component/components.dart';

import '../../modules/search/search_screen.dart';

class ShopeHomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, state) {

      },
      builder: (context,state){
        var cubit =ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title:Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    navigateTo(context, SearchScreen());
                  },
                  icon: Icon(Icons.search_outlined),
              ),
            ],
          ),
          body: cubit.bottumScreenes[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index){
              cubit.changeButtom(index);
            },
            currentIndex: cubit.currentIndex,
            items:const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
              BottomNavigationBarItem(icon: Icon(Icons.category_outlined),label: 'Category'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined), label: 'favourite'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'setting'),
            ],
          ),
        );
      }
    );
  }
}
