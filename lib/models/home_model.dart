class HomeModel {
  bool? status;
  HomeDataModel? data;
  HomeModel.forJson(Map<String, dynamic>json){
    status=json['status'];
    data=HomeDataModel.forJson(json['data']);
  }

}
class HomeDataModel {
  List<BannerModelObject> banners=[];
  List<ProductsModelObject> products=[];


  HomeDataModel.forJson(Map<String , dynamic> data){
    data['banners'].forEach((element){
      banners.add(BannerModelObject.forJson(element));
    });
    data['products'].forEach((element){
      products.add(ProductsModelObject.forJson(element));
    });
  }
}

class BannerModelObject{
  int? id;
  String? image;
  BannerModelObject.forJson(Map<String , dynamic> bannerData){
    id=bannerData['id'];
    image=bannerData['image'];
  }
}
class ProductsModelObject{

  int id=0;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  bool? inFavourites;
  bool? inCart;

  ProductsModelObject.forJson(Map<String , dynamic> productData){
    id=productData['id'];
    price=productData['price'];
    oldPrice=productData['old_price'];
    discount=productData['discount'];
    image=productData['image'];
    name=productData['name'];
    inFavourites=productData['in_favorites'];
    inCart=productData['in_cart'];
  }
}
