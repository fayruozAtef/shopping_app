class CategoriesModel {
  bool? status;
  CategoriesDataModel? data;
  CategoriesModel.forJson(Map<String , dynamic> json){
    status=json['status'];
    data=CategoriesDataModel.forJson(json['data']);

  }
}

class CategoriesDataModel{
  int? currentPage;
  List<DataModel> data=[];
  CategoriesDataModel.forJson(Map<String , dynamic> json){
    currentPage=json['current_page'];
    json['data'].forEach((element){
      data.add(DataModel.forJson(element));
    });
  }
}

class DataModel{
  int? id;
  String? name;
  String? image;

  DataModel.forJson(Map<String , dynamic> json){
    id=json['id'];
    name=json['name'];
    image=json['image'];
  }

}