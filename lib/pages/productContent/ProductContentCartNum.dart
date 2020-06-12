import 'package:flutter/material.dart';
import 'package:jdshop_app/model/ProductContentMainModel.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';

// 数据存放在model里
class ProductContentCartNum extends StatefulWidget {
  ProductContentMainItem _productContent;

  ProductContentCartNum(this._productContent,{Key key}) : super(key: key);

  @override
  _ProductContentCartNumState createState() => _ProductContentCartNumState();
}

class _ProductContentCartNumState extends State<ProductContentCartNum> {
  // 获取上个页面传入的_productContent数据
  ProductContentMainItem _productContent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._productContent = widget._productContent;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    //左侧按钮
    Widget _leftBtn() {
      return InkWell(
        onTap: () {
          // 最多减为1
          if (this._productContent.count > 1) {
            setState(() {
              this._productContent.count = this._productContent.count - 1;
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: ScreenAdaper.width(45),
          height: ScreenAdaper.height(45),
          child: Text("-"),
        ),
      );
    }

    //右侧按钮
    Widget _rightBtn() {
      return InkWell(
        onTap: (){
          setState(() {
            this._productContent.count++;
          });
        },
        child: Container(
          alignment: Alignment.center,
          width: ScreenAdaper.width(45),
          height: ScreenAdaper.height(45),
          child: Text("+"),
        ),
      );
    }

    Widget _centerArea() {
      return Container(
        alignment: Alignment.center,
        width: ScreenAdaper.width(70),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 1, color: Colors.black12),
              right: BorderSide(width: 1, color: Colors.black12),
            )),
        height: ScreenAdaper.height(45),
        child: Text("${this._productContent.count}"),
      );
    }

    return Container(
      width: ScreenAdaper.width(164),
      decoration:
      BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Row(
        children: <Widget>[
          _leftBtn(),
          _centerArea(),
          _rightBtn()
        ],
      ),
    );
  }
}
