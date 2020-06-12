import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:jdshop_app/widget/JDText.dart';

class RegisterSecondPage extends StatefulWidget {
  final Map arguments;
  RegisterSecondPage({Key key, this.arguments}) : super(key: key);

  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  // 手机号码
  String _tel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._tel = widget.arguments["tel"];
    // 调用倒计时
    _showTimer();
  }

  // 倒计时
  bool _sendCodeBtn = false;
  int _seconds = 10;
  // 倒计时
  _showTimer() {
    Timer timer;
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      // 每秒减1
      setState(() {
        this._seconds--;
      });
      // 减为0清除定时器
      if (this._seconds == 0) {
        timer.cancel();
        // 回归原样
        setState(() {
          this._sendCodeBtn = true;
        });
      }
    });
  }
  // 重新发送验证码
  sendCode() async {
    // 显示倒计时
    setState(() {
      this._sendCodeBtn = false;
      this._seconds = 10;
      this._showTimer();
    });
    // 请求验证码
    var api = '${Config.domain}api/sendCode';
    var response = await Dio().post(api, data: {"tel": this._tel});
    if (response.data["success"]) {
      print(response);  //演示期间服务器直接返回  给手机发送的验证码
    }
  }
  // 验证码
  String _code;
  // 验证验证码
  validateCode() async {
    var api = '${Config.domain}api/validateCode';
    var response = await Dio().post(api, data: {"tel": this._tel,"code": this._code});

    if (response.data["success"]) {
      Navigator.pushNamed(context, '/registerThird', arguments: {
        "tel" : this._tel,
        "code" : this._code
      });
    } else {
      Fluttertoast.showToast(
        msg: '${response.data["message"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第二步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),

            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text("验证码已经发送到了您的${this._tel}手机，请输入${this._tel}手机号收到的验证码"),
            ),
            SizedBox(height:40),

            Stack(
              children: <Widget>[
                Container(
                  child: JdText(
                    text: "请输入验证码",
                    onChanged: (value) {
                      this._code = value;
                    },
                  ),
                  height: ScreenAdaper.height(100),
                ),

                Positioned(
                  right: 0,
                  top: 0,
                  child: this._sendCodeBtn ? RaisedButton(
                    child: Text('重新发送'),
                    onPressed: sendCode
                  ) : RaisedButton(
                    child: Text('${this._seconds}秒后重发'),
                    onPressed: (){

                    },
                  ),
                )

              ],
            ),
            SizedBox(height: 20),
            JDButton(
              buttonTitle: "下一步",
              buttonColor: Colors.red,
              height: 74,
              tapEvent: validateCode
            )
          ],
        ),
      ),
    );
  }
}
