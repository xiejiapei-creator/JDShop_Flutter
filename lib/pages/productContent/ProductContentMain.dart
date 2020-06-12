//[{"cate":"鞋面材料","list":["牛皮 "]},{"cate":"闭合方式","list":["系带"]},{"cate":"颜色","list":["红色","白色","黄色"]}]

/*
   [

      {
       "cate":"尺寸",
       list":[{

            "title":"xl",
            "checked":false
          },
          {

            "title":"xxxl",
            "checked":true
          },
        ]
      },
      {
       "cate":"颜色",
       list":[{

            "title":"黑色",
            "checked":false
          },
          {

            "title":"白色",
            "checked":true
          },
        ]
      }
  ]
*/
import 'package:flutter/material.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/model/ProductContentMainModel.dart';
import 'package:jdshop_app/pages/productContent/ProductContentCartNum.dart';
import 'package:jdshop_app/provider/CartProvider.dart';
import 'package:jdshop_app/services/CartService.dart';
import 'package:jdshop_app/services/EventsBus.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductContentMainPage extends StatefulWidget {
  final List _productContentList;
  ProductContentMainPage(this._productContentList, {Key key}) : super(key: key);

  @override
  _ProductContentMainPageState createState() => _ProductContentMainPageState();
}

class _ProductContentMainPageState extends State<ProductContentMainPage>
    with AutomaticKeepAliveClientMixin {
// 获得Detail数据
  ProductContentMainItem _productContent;
// 获得属性数据
  List _attr = [];
// 选中值
  String _selectedValue;
// TODO: implement wantKeepAlive (缓存）
  bool get wantKeepAlive => true;
// 取消全局监听
  var _actionEventBus;
// provider
  CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();

    // 赋值
    this._productContent = widget._productContentList[0];
    this._attr = this._productContent.attr;
    // 初始化Attr 格式化数据
    _initAttr();

    // 监听广播,调用方法
    // 区别状态管理：重新触发build方法刷新页面
    this._actionEventBus = eventBus.on<ProductContentEvent>().listen((str) {
      this._attrBottomSheet();
    });
  }

  // 销毁事件监听
  void dispose() {
    super.dispose();

    this._actionEventBus.cancel();
  }

//初始化Attr 格式化数据
  _initAttr() {
    // 第一条为默认选中
    List attr = this._attr;
    for (var i = 0; i < attr.length; i++) {
      // 防止多次调用，清空之前旧数据再添加
      attr[i].attrList.clear();

      for (var j = 0; j < attr[i].list.length; j++) {
        if (j == 0) {
          attr[i].attrList.add({"title": attr[i].list[j], "checked": true});
        } else {
          attr[i].attrList.add({"title": attr[i].list[j], "checked": false});
        }
      }
    }

    // print(attr[0].attrList);
    // print(attr[0].cate);
    // print(attr[0].list);

    this._attr = attr;

    // 获取选中值
    _getSelectedAttrValue();
  }

//改变属性值
  _changeAttr(cate, title, setBottomState) {
    var attr = this._attr;
    for (var i = 0; i < attr.length; i++) {
      if (attr[i].cate == cate) {
        for (var j = 0; j < attr[i].attrList.length; j++) {
          attr[i].attrList[j]["checked"] = false;
          if (title == attr[i].attrList[j]["title"]) {
            attr[i].attrList[j]["checked"] = true;
          }
        }
      }
    }
    setBottomState(() {
      //注意  改变showModalBottomSheet里面的数据 来源于StatefulBuilder
      this._attr = attr;
    });
    // 获取选中值
    _getSelectedAttrValue();
  }

//获取选中的值
  _getSelectedAttrValue() {
    var _list = this._attr;
    List tempArr = [];
    for (var i = 0; i < _list.length; i++) {
      for (var j = 0; j < _list[i].attrList.length; j++) {
        if (_list[i].attrList[j]['checked'] == true) {
          tempArr.add(_list[i].attrList[j]["title"]);
        }
      }
    }
    // print(tempArr.join(','));
    setState(() {
      this._selectedValue = tempArr.join(',');

      // 给选中的属性赋予值
      this._productContent.selectedAttr = this._selectedValue;
    });
  }

//循环具体属性
  List<Widget> _getAttrItemWidget(attrItem, setBottomState) {
    List<Widget> attrItemList = [];
    attrItem.attrList.forEach((item) {
      attrItemList.add(Container(
        margin: EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            // 切换选中Tag
            _changeAttr(attrItem.cate, item["title"], setBottomState);
          },
          child: Chip(
            // Tag属性
            label: Text("${item["title"]}",
                style: TextStyle(
                    color: item["checked"] ? Colors.white : Colors.black54)),
            padding: EdgeInsets.all(10),
            backgroundColor: item["checked"] ? Colors.red : Colors.black26,
          ),
        ),
      ));
    });
    return attrItemList;
  }

//封装一个组件 渲染attr
  List<Widget> _getAttrWidget(setBottomState) {
    List<Widget> attrList = [];
    // 解决List<dynamic> is not a subtype of type 'List<Widget>'问题
    // map循环是动态类型
    // for Each 代替map循环 去掉toList()
    this._attr.forEach((attrItem) {
      attrList.add(Wrap(
        // 右侧内容较多，防止溢出
        children: <Widget>[
          // Container 用来调整text和wrap的左右位置和宽度
          Container(
            width: ScreenAdaper.width(120),
            child: Padding(
              padding: EdgeInsets.only(top: ScreenAdaper.height(22)),
              child: Text("${attrItem.cate}: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            width: ScreenAdaper.width(590),
            child: Wrap(
              children: _getAttrItemWidget(attrItem, setBottomState),
            ),
          )
        ],
      ));
    });

    return attrList;
  }

//底部弹出框
  _attrBottomSheet() {
    // BottomSheet 和 ProductMainPage不在同样一个界面,setState无法刷新BottomSheet
    // StatefulBuilder可以刷新setState无法刷新BottomSheet
    showModalBottomSheet(
        context: context,
        builder: (contex) {
          return StatefulBuilder(
            builder: (BuildContext context, setBottomState) {
              // InkWell 自带水墨纹点击效果，GestureDetector没有
              return GestureDetector(
                // 点击穿透问题:禁止
                behavior: HitTestBehavior.opaque,

                //解决showModalBottomSheet点击消失的问题
                onTap: () {
                  return false;
                },
                child: Stack(
                  children: <Widget>[
                    // 选项
                    Container(
                      padding: EdgeInsets.all(ScreenAdaper.width(20)),
                      child: ListView(
                        children: <Widget>[
                          // 取消按钮
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              child: Icon(Icons.cancel),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          // 选项
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _getAttrWidget(setBottomState)),

                          // 数量增减
                          Divider(),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: ScreenAdaper.height(80),
                            child: Row(
                              children: <Widget>[
                                Text("数量: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                // 左右加点间距
                                SizedBox(width: 10),
                                ProductContentCartNum(this._productContent)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    // 底部按钮
                    Positioned(
                      bottom: 0,
                      width: ScreenAdaper.width(750),
                      height: ScreenAdaper.height(76),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: JDButton(
                                buttonTitle: "加入购物车",
                                buttonColor: Color.fromRGBO(253, 1, 0, 0.9),
                                tapEvent: () async {
                                  // 调用加入购物车服务改变数据
                                  await CartService.addCart(
                                      this._productContent);

                                  // 弹出页面消失
                                  Navigator.pop(context);
                                  // Navigator.of(context).pop();

                                  // 先加入购物车后再更新数据
                                  this._cartProvider.updateCartList();

                                  // 弹出提示框
                                  Fluttertoast.showToast(
                                      msg: "加入购物车成功",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: JDButton(
                                buttonTitle: "立即购买",
                                buttonColor: Color.fromRGBO(253, 165, 0, 0.9),
                                tapEvent: () {
                                  // 弹出页面消失
                                  Navigator.pop(context);
                                  // Navigator.of(context).pop();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //处理图片
    String pic = Config.domain + this._productContent.pic;
    pic = pic.replaceAll('\\', '/');

    // 获取CartProvider
    this._cartProvider = Provider.of<CartProvider>(context);

    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        // 可上下滚动
        children: <Widget>[
          // 图片宽高比
          AspectRatio(
            aspectRatio: 16 / 16,
            child: Image.network("${pic}", fit: BoxFit.cover),
          ),
          //标题
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text("${this._productContent.title}",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: ScreenAdaper.fontSize(36))),
          ),
          // 二级标题
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text("${this._productContent.subTitle}",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenAdaper.fontSize(28)))),
          //价格
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                // 均匀分配
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text("特价: "),
                      Text("¥${this._productContent.price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: ScreenAdaper.fontSize(46))),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("原价: "),
                      Text("¥${this._productContent.oldPrice}",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: ScreenAdaper.fontSize(28),
                              decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                )
              ],
            ),
          ),

          // 当没有筛选项目时候不显示
          this._attr.length > 0
              ? Container(
                  margin: EdgeInsets.only(top: 10),
                  height: ScreenAdaper.height(80),
                  child: InkWell(
                    onTap: () {
                      _attrBottomSheet();
                    },
                    child: Row(
                      children: <Widget>[
                        Text("已选: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${this._selectedValue}")
                      ],
                    ),
                  ),
                )
              : Text(""),
          Divider(),

          // 运费
          Container(
            height: ScreenAdaper.height(80),
            child: Row(
              children: <Widget>[
                Text("运费: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("免运费")
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
