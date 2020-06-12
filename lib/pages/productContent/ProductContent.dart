import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/model/ProductContentMainModel.dart';
import 'package:jdshop_app/pages/productContent/ProductContentDetail.dart';
import 'package:jdshop_app/pages/productContent/ProductContentMain.dart';
import 'package:jdshop_app/pages/productContent/ProductContentRate.dart';
import 'package:jdshop_app/provider/CartProvider.dart';
import 'package:jdshop_app/services/CartService.dart';
import 'package:jdshop_app/services/EventsBus.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:jdshop_app/widget/LoadingWidget.dart';
import 'package:provider/provider.dart';

class ProductContentPage extends StatefulWidget {
  final Map arguments;
  ProductContentPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductContentPageState createState() => _ProductContentPageState();
}

class _ProductContentPageState extends State<ProductContentPage> {
  // provider
  CartProvider _cartProvider;

  // 请求详情页面数据 Model
  // List 方便判断是否存在数据
  List _productContentList = [];
  _getDetailData() async {
    var api = "${Config.domain}api/pcontent?id=${widget.arguments["id"]}";
    var result = await Dio().get(api);
    var proudctDetailModel = new ProductContentMainModel.fromJson(result.data);
    setState(() {
      this._productContentList.add(proudctDetailModel.result);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDetailData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    // 获取CartProvider
    this._cartProvider = Provider.of<CartProvider>(context);

    return DefaultTabController(
      length: 3, // tab 数量
      child: Scaffold(
          appBar: AppBar(
            // Tab位于导航栏位置处
            title: Row(
              // 让导航栏内容居中
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  // 设置宽度让导航栏三个按钮更加紧凑
                  width: ScreenAdaper.width(400),
                  child: TabBar(
                    // 底部指示器线条为红色
                    indicatorColor: Colors.red,
                    // 底部指示器线条和标题等宽
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: <Widget>[
                      Tab(
                        child: Text("商品"),
                      ),
                      Tab(
                        child: Text("详情"),
                      ),
                      Tab(
                        child: Text("评价"),
                      ),
                    ],
                  ),
                )
              ],
            ),

            // 右边按钮
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_horiz), // ...
                // 弹出下拉菜单
                onPressed: () {
                  showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          ScreenAdaper.width(600), 100, 10, 0),
                      items: [
                        PopupMenuItem(
                          child: Row(
                            // 左图标右文字
                            children: <Widget>[Icon(Icons.home), Text("首页")],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            // 左图标右文字
                            children: <Widget>[Icon(Icons.search), Text("搜索")],
                          ),
                        )
                      ]);
                },
              )
            ],
          ),
          body: this._productContentList.length > 0
              ? Stack(
                  children: <Widget>[
                    // 页面
                    TabBarView(
                      // 禁止详情页面上下和左右滑动冲突问题
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        // 父组件向子组件传值非常简单直接传
                        ProductContentMainPage(this._productContentList),
                        ProductContentDetailPage(this._productContentList),
                        ProductContentRatePage()
                      ],
                    ),

                    // 底部按钮
                    Positioned(
                      width: ScreenAdaper.width(750),
                      height: ScreenAdaper.height(88),
                      bottom: 0,
                      child: Container(
                        // 顶部添加一根线条
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(
                                    color: Colors.black26, width: 1))),
                        child: Row(
                          // 左购物车 右按钮
                          children: <Widget>[
                            // 购物车
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/cart");
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: ScreenAdaper.height(10)),
                                width: 100,
                                height: ScreenAdaper.height(88),
                                child: Column(
                                  // 上图标 下标题
                                  children: <Widget>[
                                    Icon(Icons.shopping_cart, size: ScreenAdaper.fontSize(36)),
                                    Text("购物车", style: TextStyle(fontSize: ScreenAdaper.fontSize(22)))
                                  ],
                                ),
                              ),
                            ),

                            // 添加购物车
                            Expanded(
                                // 自适应
                                flex: 1,
                                child: JDButton(
                                  buttonColor: Color.fromRGBO(253, 1, 0, 0.9),
                                  buttonTitle: "加入购物车",
                                  // 事件广播，在其他页面调用方法
                                  tapEvent: () async {
                                    if (this._productContentList[0].attr.length > 0) {
                                      // 弹出筛选框
                                      eventBus.fire(new ProductContentEvent("加入购物车"));
                                    } else {
                                      // 调用加入购物车服务改变数据
                                      await CartService.addCart(this._productContentList[0]);

                                      // 先加入购物车后再更新数据
                                      this._cartProvider.updateCartList();

                                      // 弹出提示框
                                      Fluttertoast.showToast( msg: "加入购物车成功", toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER);
                                    }
                                  },
                                )),

                            // 立即购买
                            Expanded(
                                // 自适应
                                flex: 1,
                                child: JDButton(
                                  buttonColor: Color.fromRGBO(255, 165, 0, 0.9),
                                  buttonTitle: "立即购买",
                                  tapEvent: () {
                                    // 是否有属性
                                    if (this
                                            ._productContentList[0]
                                            .attr
                                            .length >
                                        0) {
                                      // 弹出筛选框
                                      eventBus.fire(
                                          new ProductContentEvent("立即购买"));
                                    } else {
                                      print("立即购买");
                                    }
                                  },
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : LoadingWidget()),
    );
  }
}
