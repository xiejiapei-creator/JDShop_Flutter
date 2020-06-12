import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/pages/tabs/Tabs.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/Storage.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:jdshop_app/widget/JDText.dart';

class RegisterThirdPage extends StatefulWidget {
  Map arguments;
  RegisterThirdPage({Key key, this.arguments}) : super(key: key);

  _RegisterThirdPageState createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage> {
  // 传入的值
  String _tel, _code;
  String  _password = "";
  String _repassword = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._tel = widget.arguments["tel"];
    this._code = widget.arguments["code"];
  }

  // 注册
  doRegister() async {
    if (this._password.length < 6) {
      Fluttertoast.showToast(
        msg: '密码长度不能太短',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else if (this._password != this._repassword) {
      Fluttertoast.showToast(
        msg: '密码和确认密码不一致',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      var api = '${Config.domain}api/register';
      var response = await Dio().post(api, data: {"tel": this._tel,"code": this._code,"password":this._password});

      if (response.data["success"]) {
        // 保存用户信息
        await Storage.setString("userInfo", json.encode(response.data["userinfo"]));
        // 返回首页
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => new Tabs()), (route) => route == null);

      } else {
        Fluttertoast.showToast(
          msg: '${response.data["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第三步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            JdText(
              text: "请输入密码",
              password: true,
              onChanged: (value) {
                this._password = value;
              },
            ),
            SizedBox(height: 10),
            JdText(
              text: "请输入确认密码",
              password: true,
              onChanged: (value) {
                this._repassword = value;
              },
            ),
            SizedBox(height: 20),
            JDButton(
              buttonTitle: "注册",
              buttonColor: Colors.red,
              height: 74,
              tapEvent: doRegister
            )
          ],
        ),
      ),
    );
  }
}
