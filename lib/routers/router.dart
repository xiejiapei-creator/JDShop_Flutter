import 'package:flutter/material.dart';
import 'package:jdshop_app/address/AddressAdd.dart';
import 'package:jdshop_app/address/AddressEdit.dart';
import 'package:jdshop_app/address/AddressList.dart';
import 'package:jdshop_app/pages/login/Login.dart';
import 'package:jdshop_app/pages/login/RegisterFirst.dart';
import 'package:jdshop_app/pages/login/RegisterSecond.dart';
import 'package:jdshop_app/pages/login/RegisterThird.dart';
import 'package:jdshop_app/pages/productContent/CheckOut.dart';
import 'package:jdshop_app/pages/productContent/Order.dart';
import 'package:jdshop_app/pages/productContent/OrderInfo.dart';
import 'package:jdshop_app/pages/productContent/Pay.dart';
import 'package:jdshop_app/pages/productContent/ProductContent.dart';
import 'package:jdshop_app/pages/tabs/Cart.dart';
import 'package:jdshop_app/pages/tabs/ProductList.dart';
import 'package:jdshop_app/pages/tabs/Search.dart';
import 'package:jdshop_app/pages/tabs/Tabs.dart';

//配置路由
final routes = {
  '/': (context) => Tabs(),
  '/cart':(context) => CartPage(),
  '/login':(context) => LoginPage(),
  '/registerFirst':(context) => RegisterFirstPage(),
  '/registerSecond': (context,{arguments}) => RegisterSecondPage(arguments: arguments),
  '/registerThird':(context,{arguments}) => RegisterThirdPage(arguments: arguments),
  '/search': (context) => SearchPage(),
  '/productList': (context,{arguments}) => ProductListPage(arguments:arguments),
  '/productContent': (context,{arguments}) => ProductContentPage(arguments:arguments),
  '/checkOut': (context) => CheckOutPage(),
  '/addressAdd': (context) => AddressAddPage(),
  '/addressEdit': (context,{arguments}) => AddressEditPage(arguments:arguments),
  '/addressList': (context) => AddressListPage(),
  '/pay': (context) => PayPage(),
  '/order': (context) => OrderPage(),
  '/orderinfo': (context) => OrderInfoPage(),
};

//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
      MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
