import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/provider/CartProvider.dart';
import 'package:jdshop_app/provider/CheckOutProvider.dart';
import 'package:jdshop_app/services/CheckOutServices.dart';
import 'package:jdshop_app/services/EventsBus.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/SignServices.dart';
import 'package:jdshop_app/services/UserServices.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  CheckOutPage({Key key}) : super(key: key);
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  // 获取默认地址
  List _addressList=[];
  @override
  void initState() {
    super.initState();
    this._getDefaultAddress();

    //监听广播
    eventBus.on<DefaultAddressEvent>().listen((event) {
      print(event.str);
      this._getDefaultAddress();
    });
  }

  _getDefaultAddress() async {
    List userinfo = await UserServices.getUserInfo();
    var tempJson = {
      "uid": userinfo[0]["_id"],
      "salt": userinfo[0]["salt"]
    };
    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/oneAddressList?uid=${userinfo[0]["_id"]}&sign=${sign}';
    var response = await Dio().get(api);
    setState(() {
      this._addressList=response.data['result'];
    });
  }


  CheckOutProvider _checkOutProvider;
  // 商品Item UI
  Widget _checkOutItem(item) {
    return Row(
      children: <Widget>[
        // 图片
        Container(
          width: ScreenAdaper.width(160),
          child: Image.network(
              "${item["pic"]}",
              fit: BoxFit.cover),
        ),

        // 标题
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${item["title"]}", maxLines: 2),
                  Text("${item["selectedAttr"]}", maxLines: 2),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text("￥${item["price"]}", style: TextStyle(color: Colors.red)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("x${item["count"]}"),
                      )
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    // 获取结算商品数据
    this._checkOutProvider = Provider.of<CheckOutProvider>(context);
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("结算"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            // 滑动列表
            children: <Widget>[

              // 地址
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    this._addressList.length == 0 ? ListTile(
                      leading: Icon(Icons.add_location),
                      title: Center(
                        // 使文本居中
                        child: Text("请添加收获地址"),
                      ),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.pushNamed(context, "/addressAdd");
                      },
                    ) : ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${this._addressList[0]["name"]}  ${this._addressList[0]["phone"]}"),
                          SizedBox(height: 10),
                          Text("${this._addressList[0]["address"]}"),
                        ],
                      ),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.pushNamed(context, '/addressList');
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 20),

              // 商品列表
              Container(
                padding: EdgeInsets.all(ScreenAdaper.width(20)),
                child: Column(
                  children: this._checkOutProvider.checkOutListData.map((item){
                    return Column(
                      children: <Widget>[
                        _checkOutItem(item),
                        Divider()
                      ],
                    );
                  }).toList()
                ),
              ),

              // 运费
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(ScreenAdaper.width(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("商品总金额:￥100"),
                    Divider(),
                    Text("立减:￥5"),
                    Divider(),
                    Text("运费:￥0"),
                  ],
                ),
              ),
            ],
          ),

          // 按钮条
          Positioned(
            bottom: 0,
            width: ScreenAdaper.width(750),
            height: ScreenAdaper.height(100),
            child: Container(
              padding: EdgeInsets.all(5),
              width: ScreenAdaper.width(750),
              height: ScreenAdaper.height(100),
              // 线条
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(
                          width: 1,
                          color: Colors.black26
                      )
                  )
              ),

              child: Stack(
                children: <Widget>[
                  // 总价
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("总价:￥140", style: TextStyle(color: Colors.red)),
                  ),

                  // 立即下单
                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      child:
                      Text('立即下单', style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      onPressed: () async {
                        // 有默认收获地址才可以下单
                        if (this._addressList.length > 0) {
                          List userinfo = await UserServices.getUserInfo();

                          //注意：商品总价保留一位小数
                          var allPrice = CheckOutServices.getAllPrice(_checkOutProvider.checkOutListData).toStringAsFixed(1);

                          //获取签名
                          var sign = SignServices.getSign({
                            "uid": userinfo[0]["_id"],
                            "phone": this._addressList[0]["phone"],
                            "address": this._addressList[0]["address"],
                            "name": this._addressList[0]["name"],
                            "all_price":allPrice,
                            "products": json.encode(_checkOutProvider.checkOutListData),
                            "salt":userinfo[0]["salt"]   //私钥
                          });

                          //请求接口
                          var api = '${Config.domain}api/doOrder';
                          var response = await Dio().post(api, data: {
                            "uid": userinfo[0]["_id"],
                            "phone": this._addressList[0]["phone"],
                            "address": this._addressList[0]["address"],
                            "name": this._addressList[0]["name"],
                            "all_price":allPrice,
                            "products": json.encode(_checkOutProvider.checkOutListData),
                            "sign": sign
                          });

                          if(response.data["success"]){
                            //删除购物车选中的商品数据
                            await CheckOutServices.removeUnSelectedCartItem();

                            //调用CartProvider更新购物车数据
                            cartProvider.updateCartList();

                            //跳转到支付页面
                            Navigator.pushNamed(context, '/pay');
                          }
                        } else {
                          Fluttertoast.showToast( msg: "请先填写收获地址", toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )

        ],
      ),


    );
  }
}
