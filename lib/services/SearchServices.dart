import 'package:jdshop_app/services/Storage.dart';
import 'dart:convert';

class SearchServices {
  // 保存历史搜索记录到本地缓存里
  static setHistoryData(keywords) async {
    /*
          1、获取本地存储里面的数据  (searchList)
          2、判断本地存储是否有数据
              2.1、如果有数据
                    1、读取本地存储的数据
                    2、判断本地存储中有没有当前数据，
                        如果有不做操作、
                        如果没有当前数据,本地存储的数据和当前数据拼接后重新写入
              2.2、如果没有数据
                    直接把当前数据放在数组中写入到本地存储
     */
    try {
      // 将json字符串转化为map数组
      List searchListData = json.decode(await Storage.getString('searchList'));

      // 判断本地存储是否有数据: 判断数组中是否有某个值
      var hasKeywords = searchListData.any((value) {
        return value == keywords;
      });

      // 如果没有当前数据:本地存储的数据和当前数据拼接后重新写入
      if (!hasKeywords) {
        searchListData.add(keywords);
        await Storage.setString('searchList', json.encode(searchListData));
      }
    } catch (error) {// 获取不到数据，为空
      // 直接把当前数据放在数组中写入到本地存储
      List tempList = new List();
      tempList.add(keywords);
      // 将数组转化为字符串
      await Storage.setString('searchList', json.encode(tempList));
    }

  }
  // 从本地缓存里取出历史搜索记录
  static getHistoryData() async {
    try {
      List searchListData =  json.decode(await Storage.getString('searchList'));
      return searchListData;
    } catch(error) {
      return [];// 无数据返回空数组
    }
  }

  // 清空历史记录
  static clearHistoryList() async{
    await Storage.remove('searchList');
  }

  // 长按删除某条历史记录
  static removeHistoryData(keywords) async{
    List searchListData = json.decode(await Storage.getString('searchList'));
    searchListData.remove(keywords);
    await Storage.setString('searchList', json.encode(searchListData));
  }

}