
import 'package:shared_preferences/shared_preferences.dart';

class CachHelper {
  static late SharedPreferences sharedpreferences;

  static init() async {
    sharedpreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putDataInSharedPreference({
    required dynamic value,
    required String key,
  }) async {
    if(value is String)
      return await sharedpreferences.setString(key, value);
    if(value is int)
      return await sharedpreferences.setInt(key, value);
    if(value is bool)
      return await sharedpreferences.setBool(key, value);
   else
      return await sharedpreferences.setDouble(key, value);
  }


  static dynamic getDataFromSharedPreference({
    required String key,
  }) {
    return sharedpreferences.get(key);
  }

  static Future<bool> clearDataFromSharedPreference({
    required String key,
  }) async{
    return await sharedpreferences.remove(key);
  }
}
