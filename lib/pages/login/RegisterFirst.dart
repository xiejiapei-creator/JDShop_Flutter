import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:jdshop_app/widget/JDText.dart';

class RegisterFirstPage extends StatefulWidget {
  RegisterFirstPage({Key key}) : super(key: key);

  _RegisterFirstPageState createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage> {
  // 手机号：直接点击提交赋值为空
  String _tel = "";
  // 发送验证码
  sendCode() async {
    // 验证手机号码是否正确
    RegExp reg = RegExp(r"^1\d{10}$");
    if (reg.hasMatch(this._tel)) {
      var api = "${Config.domain}api/sendCode";
      var response = await new Dio().post(api,data: {"tel":this._tel});
      if (response.data["success"]) {
        print(response);  //演示期间服务器直接返回  给手机发送的验证码
        Navigator.pushNamed(context, '/registerSecond', arguments: {
          "tel":this._tel
        });
      } else {
        Fluttertoast.showToast(msg: "${response.data["message"]}",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(msg: "手机号码格式不正确",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第一步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            JdText(
              text: "请输入手机号",
              onChanged: (value) {
                this._tel = value;
              },
            ),
            SizedBox(height: 20),
            JDButton(
              buttonTitle: "下一步",
              buttonColor: Colors.red,
              height: 74,
              tapEvent: sendCode
            )
          ],
        ),
      ),
    );
  }
}
