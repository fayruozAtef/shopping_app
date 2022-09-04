import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/layout/shop_app/cubit/states.dart';
import 'package:shoping/models/category_details_model.dart';
import 'package:shoping/models/change_favourite_model.dart';
import 'package:shoping/models/favorites_model.dart';
import 'package:shoping/models/home_model.dart';
import 'package:shoping/models/login_models.dart';
import 'package:shoping/modules/categoies/categories_screen.dart';
import 'package:shoping/modules/category_details/category_details_screen.dart';
import 'package:shoping/modules/favorites/favourites_screen.dart';
import 'package:shoping/modules/settings/settings_screen.dart';
import 'package:shoping/shared/component/constants.dart';
import 'package:shoping/shared/network/end_points.dart';
import 'package:shoping/shared/network/remote/dio_helper.dart';
import '../../../models/categories_model.dart';
import '../../../modules/product/products_screen.dart';

class ShopCubit extends Cubit<ShopStates>{

  ShopCubit(): super(ShopInitialState());

  static ShopCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0 ;

  List<Widget> bottumScreenes=[
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen(),
  ];
  List<String> titles=[
    'Home',
    'Categories',
    'Favourites',
    'Setting',
  ];

  void changeButtom(int index){
    currentIndex=index;
    emit(ShopChangeButtomNavBarState());
  }

  //Get data for the home page
  HomeModel? homeModel;

  Map<int , bool> favourites={};

  void getHomeData(){
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
        url: HOME,
      token: TOKEN,
    ).then((value) {
      homeModel=HomeModel.forJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favourites.addAll({
          element.id : element.inFavourites!,
        });
      });
      emit(ShopSucessGetHomeDataState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorGetHomeDataState(error.toString()));
    });
  }

  //Get data for categories
  CategoriesModel? categoriesModel;

  void getCategoriesData(){

    DioHelper.getData(
      url: GET_CATEGORIES,
      token: TOKEN,
    ).then((value) {
      categoriesModel=CategoriesModel.forJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorCategoriesState(error.toString()));
    });
  }

  ChangeFavoriteModel? favouriteModel;

  void changeFavorites({
  required int productId,
   bool fromHome=true,
}){
    fromHome? favourites[productId]= ! favourites[productId]! :  categoryFavorite[productId]= ! categoryFavorite[productId]! ;
    emit(ShopChangeFavoriteState());
    DioHelper.postData(
        token: TOKEN,
        url: FAVOTITES,
        data: {
          'product_id' : productId,
        }
    ).then((value){
      favouriteModel =ChangeFavoriteModel.forJson(value.data);
      if(!favouriteModel!.status) {
        fromHome? favourites[productId]= ! favourites[productId]! :  categoryFavorite[productId]= ! categoryFavorite[productId]! ;
      }else{
        getFavoriteData();
      }
      emit(ShopSuccessChangeFavoriteState(favouriteModel!));
    }).catchError((error){
      favourites[productId] = !favourites[productId]!;
      emit(ShopErrorChangeFavoriteState(error.toString()));
    });
  }


  FavoritesModel? favoriteModel;

  void getFavoriteData(){
    emit(ShopLoadingFavoriteState());
    DioHelper.getData(
      url: FAVOTITES,
      token: TOKEN,
    ).then((value) {
      favoriteModel=FavoritesModel.fromJson(value.data);
      emit(ShopSucessGetFavoriteState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorGetFavoriteState());
    });
  }

  LoginModel? userModel;

  void getUserData(){
    emit(ShopLoadingUserState());
    DioHelper.getData(
      url: PROFILE,
      token: TOKEN,
    ).then((value) {
      userModel=LoginModel.fromJson(value.data);
      emit(ShopSucessUserDataState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorGetUserState());
    });
  }

  void updateUserData({
  required String name,
  required String email,
  required String phone,
}){
    emit(ShopLoadingUpdateProfileDataState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: TOKEN,
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value) {
      userModel=LoginModel.fromJson(value.data);
      emit(ShopSucessUpdateProfileDataState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorUpdateProfileDataState(error.toString()));
    });
  }

  CategoryDetailsModel? categoryDetails;
  Map<num, bool> categoryFavorite={};
  void getCategoryProducts(String id){
    categoryDetails=null;
    emit(GetCategoriesDetailsLoadingState());
    DioHelper.getData(
      url: GET_CATEGORIES+id,
      token: TOKEN,
    ).then((value) {
      categoryDetails=CategoryDetailsModel.fromJson(value.data);
      categoryDetails!.data!.products!.forEach((element) {
        categoryFavorite.addAll({
          element.id! : element.inFavorites!,
        });
      });
      emit(GetCategoriesDetailsSuccessState());
    }).catchError((onError) {
      print('Error --> '+onError.toString());
      if (onError is DioError)
        print('Dio Error --> ');
      emit(GetCategoriesDetailsErrorState(onError: onError));
    });
  }
}