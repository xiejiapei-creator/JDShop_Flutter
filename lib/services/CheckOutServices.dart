import 'dart:convert';

import 'package:jdshop_app/services/Storage.dart';

class CheckOutServices{
  //计算总价
  static getAllPrice(checkOutListData) {
    var tempAllPrice=0.0; 
    for (var i = 0; i < checkOutListData.length; i++) {
      if (checkOutListData[i]["checked"] == true) {
        tempAllPrice += checkOutListData[i]["price"] * checkOutListData[i]["count"];
      }
    }
    return tempAllPrice;
  }
  static removeUnSelectedCartItem() async{
    List _cartList=[];
    List _tempList=[];

    //获取购物车的数据
    try {
      List cartListData = json.decode(await Storage.getString('cartList'));
      _cartList = cartListData;
    } catch (error) {
      _cartList = [];
    }

    for (var i = 0; i < _cartList.length; i++) {
      if (_cartList[i]["checked"] == false) {
         _tempList.add(_cartList[i]);
      }
    }

    Storage.setString("cartList", json.encode(_tempList));
  }
}