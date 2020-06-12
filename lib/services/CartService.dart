// 服务类：涉及增加、删除购物车数据
import 'dart:convert';

import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/services/Storage.dart';

class CartService {

  // 获取购物车选中的数据
  static getCheckOutData() async {
    // 全部数据
    List cartListData = [];
    try {
      cartListData = json.decode(await Storage.getString('cartList'));
    } catch (e) {
      cartListData = [];
    }

    // 筛选选中数据
    List tempCheckOutData = [];
    for (var i = 0; i < cartListData.length; i++) {
      if (cartListData[i]["checked"] == true) {
        tempCheckOutData.add(cartListData[i]);
      }
    }
    return tempCheckOutData;
  }

  // 加入购物车: 本地加入有点类似保存历史记录，远端加入只需要上传和重新请求
  static addCart(item) async {
    // 把对象转换成Map类型的数据
    item = CartService.formatCartData(item);

    // 类似本地缓存历史记录
    try {
      List cartListData = json.decode(await Storage.getString('cartList'));
      // 是否有当前类型的数据
      bool hasData = cartListData.any((value){
        // 相同ID的商品由于属性不一样，也要另外添加一行
        if (item['_id'] == value['_id'] && item['selectedAttr'] == value['selectedAttr']) {
          return true;
        }
        return false;
      });
      if (hasData) {
        for(var i=0;i<cartListData.length;i++) {
          if(cartListData[i]['_id']==item['_id']&&cartListData[i]['selectedAttr']==item['selectedAttr']){
            cartListData[i]["count"]=cartListData[i]["count"]+1;
          }
        }
        await Storage.setString('cartList', json.encode(cartListData));
      } else {
        // 没有当前数据另外添加一行
        cartListData.add(item);
        // 数组转化为字符串后保存在本地
        await Storage.setString('cartList', json.encode(cartListData));
      }

    } catch(error) {
      // 本地没有数据
      List tempList = [];
      tempList.add(item);
      // 数组转化为字符串后保存在本地
      await Storage.setString('cartList', json.encode(tempList));
    }
  }

  //过滤数据: 传入数据很多，只取走我们想要的
  static formatCartData(item) {
    // 照片
    String sPic = item.pic;
    sPic = Config.domain + sPic.replaceAll('\\', '/');

    final Map data = new Map<String, dynamic>();
    // 唯一ID用于删除添加
    data['_id'] = item.sId;
    data['title'] = item.title;

    // 处理string和int类型的购物出价格
    if (item.price is int || item.price is double) {
      data['price'] = item.price;
    } else {
      data['price'] = double.parse(item.price);
    }

    data['selectedAttr'] = item.selectedAttr;
    data['count'] = item.count;
    data['pic'] = sPic;

    //是否选中,默认加入购物车即选中
    data['checked'] = true;

    return data;
  }
}


/*
      1、获取本地存储的cartList数据
      2、判断cartList是否有数据
            有数据：
                1、判断购物车有没有当前数据：
                        有当前数据：
                            1、让购物车中的当前数据数量 等于以前的数量+现在的数量
                            2、重新写入本地存储

                        没有当前数据：
                            1、把购物车cartList的数据和当前数据拼接，拼接后重新写入本地存储。

            没有数据：
                1、把当前商品数据以及属性数据放在数组中然后写入本地存储



                List list=[
                  {"_id": "1",
                    "title": "磨砂牛皮男休闲鞋-有属性",
                    "price": 688,
                    "selectedAttr": "牛皮 ,系带,黄色",
                    "count": 4,
                    "pic":"public\upload\RinsvExKu7Ed-ocs_7W1DxYO.png",
                    "checked": true
                  },
                    {"_id": "2",
                    "title": "磨xxxxxxxxxxxxx",
                    "price": 688,
                    "selectedAttr": "牛皮 ,系带,黄色",
                    "count": 2,
                    "pic":"public\upload\RinsvExKu7Ed-ocs_7W1DxYO.png",
                    "checked": true
                  }

                ];


*/