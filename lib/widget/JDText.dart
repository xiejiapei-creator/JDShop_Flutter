import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';

class JdText extends StatelessWidget {

  // final常量
  final String text;
  final bool password;
  final Object onChanged;
  final int maxLines;
  final double height;
  final TextEditingController controller;
  JdText({Key key,this.text="输入内容",this.password=false,this.onChanged=null,this.maxLines=1,this.height=68,this.controller=null}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenAdaper.height(this.height),

      // 文本框
      child: TextField(
        controller: controller,
        maxLines: this.maxLines,
        obscureText: this.password,
        decoration: InputDecoration(
            hintText: this.text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
        onChanged: this.onChanged,
      ),

      // 底部线条
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: Colors.black12
              )
          )
      ),
    );
  }
}