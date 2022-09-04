import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping/models/search_model.dart';
import 'package:shoping/modules/search/cubit/states.dart';
import 'package:shoping/shared/component/constants.dart';
import 'package:shoping/shared/network/remote/dio_helper.dart';

import '../../../shared/network/end_points.dart';

class SearchCubit extends Cubit<SearchStates>{

  SearchCubit(): super(SearchInitialState());

  static SearchCubit get(context) =>BlocProvider.of(context);

  SearchModel? searchModel;

  void getSearch(String text){
    emit(SearchLoadingState());
    DioHelper.postData(
        url: SEARCH_PRODUCT,
        token: TOKEN,
        data: {
          'text' : text,
        }).then((value) {
          searchModel=SearchModel.fromJson(value.data);
          emit(SearchSucessState());
    }).catchError((error){
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}