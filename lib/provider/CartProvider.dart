import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jdshop_app/services/Storage.dart';

// Provider: 存放购物车数据，存放全选状态
class CartProvider with ChangeNotifier {
  List _cartList = [];
  // 底部Num
  int get cartNum=>this._cartList.length;
  // 列表
  List get cartList=>this._cartList;

  // 初始化赋值,获取购物车数据
  CartProvider(){
    this.init();
  }

  init() async {
    // 判断有无数据
    try {
      this._cartList = json.decode(await Storage.getString("cartList"));
    } catch (error) {
      // 无数据则置为空
      this._cartList = [];
    }

    // 获取是否第一次全选
    this._isCheckAll = this.isFirstCheckAll();

    //计算总价
    this.computeAllPrice();

    // 通知其他组件更新数据
    notifyListeners();
  }

  // 更新列表数据
  updateCartList() {
    init();
  }

  // 全选
  bool _isCheckAll = false;
  // 获取私有属性
  bool get isCheckAll=>this._isCheckAll;
  // 全选反选
  checkAll(value) async {
    this._cartList.forEach((item) {
      item["checked"] = value;
    });
    this._isCheckAll = value;
    //计算总价
    this.computeAllPrice();
    await Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }
  // 判断刚进入页面时候是否处于全选状态
  bool isFirstCheckAll() {
    if (this._cartList.length > 0) {
      for (var i = 0; i < this._cartList.length; i++) {
        if (this._cartList[i]["checked"] == false) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  // + - 后将数据保存到本地
  // 监听每一项的选中事件，使列表和全选按钮保持同步
  itemChange() async {
    if (this.isFirstCheckAll()) {
      this._isCheckAll = true;
    } else {
      this._isCheckAll = false;
    }
    // 计算总价
    this.computeAllPrice();
    await Storage.setString("cartList", json.encode(this._cartList));
    // 通知其他页面更新
    notifyListeners();
  }

  itemCountChange() {
    Storage.setString("cartList", json.encode(this._cartList));
    //计算总价
    this.computeAllPrice();

    notifyListeners();
  }

  // 删除商品
  removeItem() async {
    List tempList = [];
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == false) {
        // ['1111','2222','333333333','4444444444']
        // 数组删除后会向前移动一位，导致删除2222（索引1）后，再删除（索引2）就会变成删除444444
        // this._cartList.removeAt(i);

        tempList.add(this._cartList[i]);
      }
    }
    this._cartList = tempList;
    // 计算总价
    this.computeAllPrice();
    await Storage.setString("cartList", json.encode(this._cartList));
    // 通知其他页面更新
    notifyListeners();
  }

  // 总价
  double _allPrice = 0; //总价
  double get allPrice => this._allPrice;
  // 计算总价
  computeAllPrice() {
    double tempAllPrice = 0;
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == true) {
        tempAllPrice += this._cartList[i]["price"] * this._cartList[i]["count"];
      }
    }
    this._allPrice = tempAllPrice;

    notifyListeners();
  }
}