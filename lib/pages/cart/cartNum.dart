import 'package:flutter/material.dart';
import 'package:jdshop_app/provider/CartProvider.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:provider/provider.dart';

class CartNum extends StatefulWidget {
  Map _itemData;
  CartNum(this._itemData, {Key key}) : super(key: key);

  @override
  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  CartProvider _cartProvider;

  // 获得上一个页面传入的数据
  Map _itemData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._itemData = widget._itemData;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    this._cartProvider = Provider.of<CartProvider>(context);

    //左侧按钮
    Widget _leftBtn() {
      return InkWell(
        onTap: () {
          if (this._itemData["count"] > 1) {
            // 数据不是直接绑定在provider
            this._itemData["count"] = this._itemData["count"] - 1;
            // 但没有存储到本地，重新运行后值还是以前的
            this._cartProvider.itemCountChange();
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
          // 改变了_cartList的值
          this._itemData["count"] = this._itemData["count"] + 1;
          // 但没有存储到本地，重新运行后值还是以前的
          this._cartProvider.itemCountChange();
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
              left: BorderSide(width: ScreenAdaper.width(2), color: Colors.black12),
              right: BorderSide(width: ScreenAdaper.width(2), color: Colors.black12),
            )),
        height: ScreenAdaper.height(45),
        child: Text("${this._itemData["count"]}"),
      );
    }

    return Container(
      width: ScreenAdaper.width(168),
      decoration:
      BoxDecoration(border: Border.all(width: ScreenAdaper.width(2), color: Colors.black12)),
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
