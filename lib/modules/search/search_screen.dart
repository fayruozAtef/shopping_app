import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/layout/shop_app/cubit/shop_cubit.dart';
import 'package:shoping/modules/search/cubit/cubit.dart';

import '../../models/search_model.dart';
import '../../shared/component/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit/states.dart';

class SearchScreen extends StatelessWidget {

  var formKey= GlobalKey<FormState>();
  var searchControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context,state){

        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultTextFormField(
                        input: TextInputType.text,
                        validate: (String? value) {
                          if (value!.isEmpty) return 'enter something to search for';
                          return null;
                        },
                        controler: searchControler,
                        icon: Icons.search,
                        lable: 'Search',
                        onChange: (value) {
                          SearchCubit.get(context).getSearch(value);
                        },
                      onSubmitted: (value){
                        if(formKey.currentState!.validate()){
                          SearchCubit.get(context).getSearch(value);
                        }
                      },
                    ),
                    const SizedBox(height: 10,),
                    if(state is SearchLoadingState)
                      LinearProgressIndicator(),
                    const SizedBox(height: 10,),
                    if(state is SearchSucessState)
                      Expanded(
                        child:ListView.separated(
                            itemBuilder:(context ,index)=> buildSearchItem(
                                SearchCubit.get(context).searchModel!.data!.data[index],
                                context,
                            ),
                            separatorBuilder: (context , index)=>myDividor(),
                            itemCount: SearchCubit.get(context).searchModel!.data!.data.length,
                        ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchItem(Product model,context)=> Padding(
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
                image: NetworkImage(model.image ?? ''),
                width: 120.0,
                height: 120.0,
                //fit: BoxFit.cover,
              ),

            ],
          ),
          const SizedBox(width: 20.0,),
          Expanded(
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
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Price: ${model.price}',
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
    ),
  );
}
