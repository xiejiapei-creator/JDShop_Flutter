import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdshop_app/pages/cart/cartItem.dart';
import 'package:jdshop_app/provider/CartProvider.dart';
import 'package:jdshop_app/provider/CheckOutProvider.dart';
import 'package:jdshop_app/services/CartService.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/UserServices.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CheckOutProvider _checkOutProvider;

  // 点击结算按钮
  doCheckOut() async {
    // 获取结算数据
    List checkOutData = await CartService.getCheckOutData();
    // 保存选中数据
    this._checkOutProvider.changeCheckOutListData(checkOutData);
    // 购物车是否有选中的数据
    if (checkOutData.length > 0) {
      // 判断用户是否登陆
      bool userLoginState = await UserServices.getUserState();
      if (userLoginState) {
        Navigator.pushNamed(context, "/checkOut");
      } else {
        Fluttertoast.showToast( msg: "请先登陆再结算", toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER);
        Navigator.pushNamed(context, "/login");
      }
    } else {
      Fluttertoast.showToast( msg: "没有选中商品哦", toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER);
    }
  }

  // 是否编辑状态支持删除
  bool _isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    // 获取通知提供的值: 全选按钮
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    // 获取结算页面的值
    this._checkOutProvider = Provider.of<CheckOutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
        actions: <Widget>[
          IconButton(
            icon: this._isEdit == false ? Icon(Icons.edit) : Icon(Icons.done),
            onPressed: () {
              // 点击后处于编辑状态
              setState(() {
                this._isEdit = !this._isEdit;
              });
            },
          )
        ],
      ),
      // 判断列表数量是否大于0
      body: cartProvider.cartList.length > 0 ? Stack(// 上ListView 下Position
        children: <Widget>[

          // 商品·列表
          ListView(
            children: <Widget>[
              // 加入Column, 商品数量多时候不会被全选按钮覆盖
              Column(
                children: cartProvider.cartList.map((value){
                  return CartItem(value);
                }).toList(),
              ),

              // 和全选按钮来点距离
              SizedBox(height: ScreenAdaper.height(100))
            ],
          ),

          // 底部按钮条
          Positioned(
            bottom: 0,
            width: ScreenAdaper.width(750),
            height: ScreenAdaper.height(78),
            child: Container(
              width: ScreenAdaper.width(750),
              height: ScreenAdaper.height(78),

              // 顶部线条
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: ScreenAdaper.width(2),
                    color: Colors.black12
                  )
                ),
                color: Colors.white
              ),

              // 左全选 右结算
              child: Stack(
                children: <Widget>[
                  // 全选
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(// 左单选框 右文本
                      children: <Widget>[
                        // 单选框
                        Container(
                          width: ScreenAdaper.width(60),
                          child: Checkbox(
                            value: cartProvider.isCheckAll,
                            activeColor: Colors.pink,
                            onChanged: (value) {
                              // 实现全选反选
                              cartProvider.checkAll(value);
                            },
                          ),
                        ),
                        // 文本
                        Text("全选"),
                        SizedBox(width: 20),
                        this._isEdit == false ? Text("合计：") : Text(""),
                        this._isEdit == false ? Text("¥ ${cartProvider.allPrice}",style: TextStyle(color: Colors.red)) : Text("")
                      ],
                    ),
                  ),

                  // 结算
                  this._isEdit == false ? Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      child: Text("结算",style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      onPressed: doCheckOut
                    ),
                  ) : Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      child: Text("删除",style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      onPressed: () {
                        // 删除数据
                        cartProvider.removeItem();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],

      ):Center(
        child: Text("购物车是空的..."),
      )
    );
  }
}