import 'package:shared_preferences/shared_preferences.dart';

class CashHelper{
  static SharedPreferences? sharedPreferences;

  static init() async{
    sharedPreferences= await SharedPreferences.getInstance();
  }

  static dynamic getBoolData({
    required String key
  })
  {
    return  sharedPreferences!.get(key);
  }

  static Future<bool> putData({
    required String key,
    required dynamic value,
  }) async{
    if(value is String) { return await sharedPreferences!.setString('$key', value); }
    else if(value is int) { return await sharedPreferences!.setInt('$key', value); }
    else if (value is double) { return await sharedPreferences!.setDouble('$key', value); }
    return await sharedPreferences!.setBool('$key', value);
  }

  static Future<bool> clearData({required String key,}) async{
    return sharedPreferences!.remove(key);
  }

}