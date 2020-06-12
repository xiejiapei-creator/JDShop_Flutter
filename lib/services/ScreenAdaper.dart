import 'package:flutter_screenutil/flutter_screenutil.dart';

// 封装静态宽、高方法，直接通过类名称来访问
class ScreenAdaper {

  // 解决Flutter 不同终端屏幕适配问题，传入context和设计稿子上的宽高
  static init(context) {
    ScreenUtil.init(context, width: 750, height: 1334);
  }

  // 获取计算后的高度: 传入int 转化为 double
  static height(double value) {
    return ScreenUtil().setHeight(value);
  }

  // 获取计算后的宽度
  static width(double value) {
    return ScreenUtil().setWidth(value);
  }

  // 获取屏幕高度
  static getScreenHeight() {
    return ScreenUtil.screenHeightDp;
  }

  // 获取屏幕宽度
  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }

  // 获取字体大小
  static fontSize(double value) {
    return ScreenUtil().setSp(value);
  }
}