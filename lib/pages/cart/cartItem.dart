import 'package:flutter/material.dart';
import 'package:jdshop_app/pages/cart/cartNum.dart';
import 'package:jdshop_app/provider/CartProvider.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  Map _itemData;
  CartItem(this._itemData,{Key key}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  // 获取item的值
  Map _itemData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 删除中间数据 _itemData 不会重新赋值，因为该initState不会被触发，但是build方法会重新触发
    // 也就是该页面_itemData仍为旧数据, 但是List数量删除后减少了，原来5条，删除中间2条后剩余3条，这样页面显示的是前面3条
    // 当重新运行的时候init执行获取数据，显示正确
    // this._itemData = widget._itemData;
  }

  @override
  Widget build(BuildContext context) {
    // 重新给该属性赋值: 只需要一次赋值，放在init里，需要多次赋予值放在build
    this._itemData = widget._itemData;
    var cartProvider = Provider.of<CartProvider>(context);

    return Container(
      height: ScreenAdaper.height(200),
      padding: EdgeInsets.all(5),

      // 底部线条
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
              width: ScreenAdaper.width(2),
              color: Colors.black12
            )
        )
      ),

      // cell
      child: Row(
        children: <Widget>[
          // 单选框
          Container(
            width: ScreenAdaper.width(60),
            child: Checkbox(
              value: this._itemData["checked"],
              activeColor: Colors.pink,
              onChanged: (value) {
                setState(() {
                  // 改变了_itemData --》 改变了_cartList
                  this._itemData["checked"] = !this._itemData["checked"];
                });
                // 判断是否全选
                cartProvider.itemChange();
              },
            ),
          ),

          // 图片
          Container(
            width: ScreenAdaper.width(160),
            child: Image.network("${this._itemData["pic"]}",fit: BoxFit.cover)
          ),

          // 标题
          Expanded(// 浮动
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Column(// 上title 下detail
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // title
                  Text("${this._itemData["title"]}",maxLines: 2),
                  // attr
                  Text("${this._itemData["selectedAttr"]}",maxLines: 2),

                  // 左：￥12  右：+-
                  Stack(
                    children: <Widget>[
                      // ￥12
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("￥${this._itemData["price"]}",style: TextStyle(
                            color: Colors.red
                        ))
                      ),

                      // +-
                      Align(
                        alignment: Alignment.centerRight,
                        child: CartNum(this._itemData),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
