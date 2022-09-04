class ChangeFavoriteModel{
  bool status =false;
  String message='';
  ChangeFavoriteModel.forJson(Map<String, dynamic>json){
    status=json['status'];
    message=json['message'];
  }
}