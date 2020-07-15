import 'dart:convert';
import 'package:jdshop_app/services/Storage.dart';

class UserServices {
  // 获取用户信息
  static getUserInfo() async {
    List userInfo;
    try {
      userInfo = json.decode(await Storage.getString('userInfo'));
    } catch (error) {
      userInfo = [];
    }
    return userInfo;
  }

  // 获取用户登陆状态
  static getUserState() async {
    List userInfo = await UserServices.getUserInfo();
    if (userInfo.length > 0 && userInfo[0]["username"] != "") {
      return true;
    }
    return false;
  }

  // 退出登陆
  static loginOut() async {
    Storage.remove("userInfo");
  }
}