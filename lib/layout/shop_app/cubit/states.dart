import 'package:shoping/models/change_favourite_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeButtomNavBarState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}

class ShopSucessGetHomeDataState extends ShopStates{}

class ShopErrorGetHomeDataState extends ShopStates{
  final String error;
  ShopErrorGetHomeDataState(this.error){
    print(error);
  }
}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesState extends ShopStates{
  final String error;
  ShopErrorCategoriesState(this.error){
    print(error);
  }
}

class ShopChangeFavoriteState extends ShopStates{}

class ShopSuccessChangeFavoriteState extends ShopStates{
    final ChangeFavoriteModel model;
    ShopSuccessChangeFavoriteState(this.model);
}

class ShopErrorChangeFavoriteState extends ShopStates{
  final String error;
  ShopErrorChangeFavoriteState(this.error){
    print(error);
  }
}

class ShopLoadingFavoriteState extends ShopStates{}

class ShopSucessGetFavoriteState extends ShopStates{}

class ShopErrorGetFavoriteState extends ShopStates{}

class ShopLoadingUserState extends ShopStates{}

class ShopSucessUserDataState extends ShopStates{}

class ShopErrorGetUserState extends ShopStates{}

class ShopLoadingUpdateProfileDataState extends ShopStates{}

class ShopSucessUpdateProfileDataState extends ShopStates{}

class ShopErrorUpdateProfileDataState extends ShopStates{
  final String error;
  ShopErrorUpdateProfileDataState(this.error);
}

class GetCategoriesDetailsLoadingState extends ShopStates{}

class GetCategoriesDetailsSuccessState extends ShopStates{}

class GetCategoriesDetailsErrorState extends ShopStates{
  dynamic onError;
  GetCategoriesDetailsErrorState({required this.onError});
}