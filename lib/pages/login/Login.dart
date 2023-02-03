import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/services/EventsBus.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/Storage.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:jdshop_app/widget/JDText.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // 登陆
  String _password = "";
  String _username = "";
  doLogin() async {
    // 验证手机号码是否正确
    RegExp reg = RegExp(r"^1\d{10}$");
    if (!reg.hasMatch(this._username)) {
      Fluttertoast.showToast(msg: "用户名格式不正确",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER);
    } else if (this._password.length < 6) {
      Fluttertoast.showToast(msg: "密码格式  不正确",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else {
      var api = "${Config.domain}api/doLogin";
      var response = await new Dio().post(api,data: {"username":this._username, "password":this._password});
      if (response.data["success"]) {
        //保存用户信息
        Storage.setString('userInfo', json.encode(response.data["userinfo"]));
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: '${response.data["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }
  // 从子页面Login回到上级页面User，不会刷新User
  // 监听登陆页面销毁的事件
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // 广播：登陆页面退出的时候，通知用户中心刷新页面
    eventBus.fire(new UserEvent("登陆成功..."));
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text("客服"),
            onPressed: () {

            },
          )
        ],
      ),

      // ListView：当键盘放不下的时候可以滑动页面
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            // 方框图
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: ScreenAdaper.height(160),
                width: ScreenAdaper.height(160),
                child: Image.network('https://i0.hdslb.com/bfs/article/eda171aacf3a5a14b659bddda2f1d02efa99ed96.jpg@1320w_866h.jpg',fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 30),

            // 用户名
            JdText(text: "请输入用户名",onChanged: (value) {
              this._username = value;
            }),
            SizedBox(height: 10),

            // 密码
            JdText(text: "请输入密码",onChanged: (value) {
              this._password = value;
            }),
            SizedBox(height: 20),

            // 忘记密码/新用户注册
            Container(
              padding: EdgeInsets.all(20),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {

                      },
                      child: Text("忘记密码"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/registerFirst');
                      },
                      child: Text("新用户注册"),
                    ),
                  )
                ],
              ),
            ),

            // 登陆按钮
            JDButton(
              buttonColor: Colors.red,
              buttonTitle: "登录",
              height: 74,
              tapEvent: doLogin
            )
          ],
        ),
      ),
    );
  }
}
