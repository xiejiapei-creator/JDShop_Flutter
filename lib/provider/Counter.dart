import 'package:flutter/material.dart';

class Counter with ChangeNotifier{

  int _count=1;  //状态

  Counter(){
    this._count=10;
  }

  int get count=>_count;  //获取状态

  intCount(){             //更新状态
    this._count++;
    notifyListeners();   //表示更新状态
  }

}