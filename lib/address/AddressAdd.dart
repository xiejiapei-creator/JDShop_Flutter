import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/services/EventsBus.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/SignServices.dart';
import 'package:jdshop_app/services/UserServices.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:jdshop_app/widget/JDText.dart';
import 'package:city_pickers/city_pickers.dart';

class AddressAddPage extends StatefulWidget {
  AddressAddPage({Key key}) : super(key: key);
  @override
  _AddressAddPageState createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  String area='';
  String name='';
  String phone='';
  String address='';

  // 页面销毁广播
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBus.fire(new AddressEvent("增加地址成功"));
    eventBus.fire(new DefaultAddressEvent('改收货地址成功...'));
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("增加收货地址"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[

            SizedBox(height: 20),
            JdText(
              text: "收货人姓名",
              onChanged: (value) {
                this.name = value;
              },
            ),
            SizedBox(height: 10),
            JdText(
              text: "收货人电话",
              onChanged: (value) {
                this.phone = value;
              },
            ),
            SizedBox(height: 10),

            // 弹出省市区
            Container(
              padding: EdgeInsets.only(left: 5),
              height: ScreenAdaper.height(68),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12))),

              child: InkWell(

                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_location),
                    this.area.length > 0 ? Text('${this.area}', style: TextStyle(color: Colors.black54)): Text('省/市/区', style: TextStyle(color: Colors.black54))
                  ],
                ),

                onTap: () async{
                  Result result = await CityPickers.showCityPicker(
                      context: context,
                      cancelWidget: Text("取消", style: TextStyle(color: Colors.blue)),
                      confirmWidget: Text("确定", style: TextStyle(color: Colors.blue))
                  );
                  setState(() {
                    this.area = "${result.provinceName}/${result.cityName}/${result.areaName}";
                  });
                },
              ),
            ),

            SizedBox(height: 10),
            JdText(
              text: "详细地址",
              maxLines: 4,
              height: 200,
              onChanged: (value) {
                this.address = "${this.area} ${value}";
              },
            ),
            SizedBox(height: 40),
            JDButton(buttonTitle: "增加", buttonColor: Colors.red, tapEvent: () async {
              // 生成签名
              List userinfo = await UserServices.getUserInfo();
              var tempJson = {
                "uid":userinfo[0]["_id"],
                "name":this.name,
                "phone":this.phone,
                "address":this.address,
                "salt":userinfo[0]["salt"]
              };
              var sign=SignServices.getSign(tempJson);
              // 网络请求
              var api = '${Config.domain}api/addAddress';
              var result = await Dio().post(api,data:{
                "uid":userinfo[0]["_id"],
                "name":this.name,
                "phone":this.phone,
                "address":this.address,
                "sign":sign
              });
              Navigator.pop(context);
            })
          ],
        ),
      )
    );
  }
}