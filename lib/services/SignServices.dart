import 'dart:convert';
import 'package:crypto/crypto.dart';

class SignServices {
  static getSign(json) {
//    Map addressListAttr={
//      "uid":'1',
//      "age":10,
//      "salt":'xxxxxxxxxxxxxx'  //私钥
//    };
    List attrKeys = json.keys.toList();
    attrKeys.sort();

    String str='';
    for(var i = 0; i < attrKeys.length; i++){
      str += "${attrKeys[i]}${json[attrKeys[i]]}";
    }
    return md5.convert(utf8.encode(str)).toString();
  }
}