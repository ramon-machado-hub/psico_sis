import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static final String _key = 'key';

  static Future<void> save (String uid) async {
    print("save $uid");
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key,
        jsonEncode({
          "uid": uid,
          "isAuth": true}
    ));
  }

  static Future<bool> isAuth() async{
    var prefs = await SharedPreferences.getInstance();
    var jsonResult = prefs.getString(_key);
    if (jsonResult!=null){
      var mapUser = jsonDecode(jsonResult);
      return mapUser['isAuth'];
    }
    return false;
  }

  static Future<String> getUid() async{
    var prefs = await SharedPreferences.getInstance();
    var jsonResult = prefs.getString(_key);
    if (jsonResult!=null){
      var mapUser = jsonDecode(jsonResult);
      return mapUser['uid'];
    }
    return "";
  }

  static logout () async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}