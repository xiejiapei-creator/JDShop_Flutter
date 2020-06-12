import 'package:flutter/material.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';

class JDButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonTitle;
  final Object tapEvent;
  final double height;
  // 默认构造函数: 不能用下划线
  JDButton({Key key, this.buttonColor = Colors.black, this.buttonTitle = "按钮",this.height = 68, this.tapEvent = null}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return InkWell(
      onTap: this.tapEvent,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        height: ScreenAdaper.height(this.height),
        width: double.infinity,
        // 边框
        decoration: BoxDecoration(
            color: this.buttonColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text("${this.buttonTitle}",style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
