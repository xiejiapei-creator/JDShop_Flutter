import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/model/FocusModel.dart';
import 'package:jdshop_app/model/ProductList.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:dio/dio.dart';
import 'package:jdshop_app/services/SearchServices.dart';
import 'package:jdshop_app/services/SignServices.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {// 缓存页面

  // 缓存当前页面,保持之前状态
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // 轮播图Model
  List _focusData = [];
  _getFocusData() async {
    var apiURL = "${Config.domain}api/focus";
    var result = await Dio().get(apiURL);
    print(result.data is Map);// String 还需要转化为Map
    var focusList = FocusModel.fromJson(result.data);

    /*
    focusList.result.forEach((item) {
      print(item.pic);
    });
    */

    setState(() {
      this._focusData = focusList.result;
    });
  }

  // 轮播图UI
  // 抽离成方法，便于维护
  // 多个页面都用到这个，还可以抽离成文件
  Widget _swiperWidget() {
    if (this._focusData.length > 0) {
      return Container(
        // 添加容器用于设置宽高
        child: AspectRatio(
          // 不同设备宽高不同，只能设置为宽高比例
          aspectRatio: 2 / 1, // 宽2 高1
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              String pic = this._focusData[index].pic;
              // ➕域名 替换斜杠
              pic = Config.domain + pic.replaceAll('\\', '/');
              return new Image.network(
                "${pic}",
                fit: BoxFit.fill,
              );
            },
            itemCount: this._focusData.length,
            pagination: new SwiperPagination(), // 分页器
            autoplay: true, // 自动轮播
          ),
        ),
      );
    } else {
      return Text("加载中...");
    }
  }

  // 标题栏
  Widget _titleWidget(value) {
    return Container(
      height: ScreenAdaper.height(32),
      child: Text(value, style: TextStyle(color: Colors.black54)),
      // 左侧红色边框
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Colors.red,
        width: ScreenAdaper.width(10),
      ))),
      // 左侧边框右移一点
      margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
      // 内部组件之间有间距, 好像只对child起作用
      padding: EdgeInsets.only(left: ScreenAdaper.width(20)),
    );
  }

  // 水平列表(猜你喜欢) Model
  List _hotProductListData = [];
  _getHotProductData() async {
    var apiURL = "${Config.domain}api/plist?is_hot=1";
    var result = await Dio().get(apiURL);
    var hotProductList = ProductListModel.fromJson(result.data);
    setState(() {
      this._hotProductListData = hotProductList.result;
    });
  }

  // 水平列表(猜你喜欢) UI
  Widget _horizontalProductListWidget() {
    if (this._hotProductListData.length > 0) {
      // ListView不能嵌套，需包装在Container中,指定宽高实现水平滑动
      return Container(
        height: ScreenAdaper.height(234),
        // 左右第一个元素不能挨边
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView.builder(

          itemCount: this._hotProductListData.length,
          itemBuilder: (context, index) {

            // 获得小图
            String sPic = this._hotProductListData[index].sPic;
            sPic = Config.domain + sPic.replaceAll('\\', '/');

            return Column(
              // 列：上图下文
              children: <Widget>[
                Container(
                  // 设置图片的宽高
                  height: ScreenAdaper.height(140),
                  width: ScreenAdaper.width(140),
                  // 设置间距
                  margin: EdgeInsets.only(right: ScreenAdaper.width(20)),
                  // index 从0开始，服务器图片从1开始
                  child: Image.network(
                    "${sPic}",
                    fit: BoxFit.cover,
                  ),
                ),

                Container(// 可设置文本宽高,便于计算整体宽高
                  padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
                  height: ScreenAdaper.height(44),
                  child: Text("${this._hotProductListData[index].price}",style: TextStyle(color: Colors.red)),
                )
              ],
            );
          },
          // 水平滑动
          scrollDirection: Axis.horizontal,
        ),
      );
    } else {
      return Text("");
    }
  }


  // 纵向列表(热门推荐） Model
  List _bestProductListData = [];
  _getBestProductData() async {
    var apiURL = "${Config.domain}api/plist?is_best=1";
    var result = await Dio().get(apiURL);
    var bestProductList = ProductListModel.fromJson(result.data);
    setState(() {
      this._bestProductListData = bestProductList.result;
    });
  }

  // 纵向列表(热门推荐） UI
  Widget _recProductListWidget() {
    
    // （ScreenAdaper.width(ScreenAdaper.getScreenWidth()) - 30）/ 2来计算
    var itemWidth = (ScreenAdaper.getScreenWidth() - 20 - 10) / 2;

    return Container(
      // 左右间距
      padding: EdgeInsets.all(10),
      child: Wrap(// GridView 只能设置宽高比，无法设置Item高度
        spacing: 10,// 水平间距(中间的10）
        runSpacing: 10,// 纵间距（上下的10）
        children: this._bestProductListData.map((value){// value为每一个Item

          String sPic = value.sPic;
          sPic = Config.domain + sPic.replaceAll('\\', '/');

          return InkWell(
            child: Container(// Item 宽高
              // 屏幕减去左右中间后的一半, 高度会自适应
              width: itemWidth,
              // 左右上下间距
              padding: EdgeInsets.all(10),
              // 边框
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black12,
                      width: 1
                  )
              ),
              child: Column(// 上图中文下价格
                children: <Widget>[

                  Container(// 防止Image以外层Container实现cover平铺
                    // 铺满外层Container（除pading外部分）
                      width: double.infinity,
                      child: AspectRatio(// 防止服务器图片宽高不一致
                          aspectRatio: 1/1,// 宽度固定的，1：1则高度也固定
                          child: Image.network("${sPic}",fit: BoxFit.cover)
                      )
                  ),

                  Padding(
                    // 和图片相距10
                    padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
                    child: Text("${value.title}",
                      maxLines: 2,
                      // ...溢出
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black54
                      ),
                    ),
                  ),

                  Padding(
                    // 和标题相距10
                    padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
                    child: Stack(// 左边打折价格 右边原价
                      children: <Widget>[
                        Align(// 中间偏左
                          alignment: Alignment.centerLeft,
                          child: Text("¥${value.price}",style: TextStyle(color: Colors.red,fontSize: 16)),
                        ),
                        Align(// 中间偏右
                          alignment: Alignment.centerRight,
                          // 下划线
                          child: Text("¥${value.oldPrice}",style: TextStyle(color: Colors.black54,fontSize: 14,decoration: TextDecoration.lineThrough)),
                        )
                      ],

                    ),
                  )
                ],
              ),
            ),
            // 跳转到详情页面
            onTap: () {
              Navigator.pushNamed(context, '/productContent', arguments: {
                "id" : value.sId
              });
            },
          );
        }).toList()
      ),
    );
  }

// JSON Data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 获取轮播图数据
    _getFocusData();
    // 获取猜你喜欢数据
    _getHotProductData();
    // 获取热门推荐数据
    _getBestProductData();
  }

@override
  Widget build(BuildContext context) {
    // 解决Flutter 不同终端屏幕适配问题，传入context和设计稿子上的宽高
    ScreenAdaper.init(context);

    return Scaffold(
      // 用户中心界面单独设置导航
      appBar: AppBar(
          leading: IconButton(// 扫描按钮
            icon: Icon(Icons.center_focus_weak,size: 28,color: Colors.black),
            onPressed: (){

            },
          ),
          actions: <Widget>[//消息按钮
            IconButton(
              icon: Icon(Icons.message,size: 28,color: Colors.black),
              onPressed: (){

              },
            )
          ],
          title: InkWell(// 搜索框支持点击
            child:Container(
              height: ScreenAdaper.height(70),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 233, 233, 0.8),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Row(// 左🔍右提示
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search),
                  Text("搜索",style: TextStyle(fontSize: ScreenAdaper.fontSize(28)))
                ],
              ),
            ),
            onTap: (){
              // 跳转到搜索页面
              Navigator.pushNamed(context, '/search');
            },
          )
      ),

      body: ListView(
        // 支持上下滑动
        children: <Widget>[
          _swiperWidget(),
          SizedBox(height: ScreenAdaper.height(20)),
          _titleWidget("猜你喜欢"),
          SizedBox(height: ScreenAdaper.height(20)),
          _horizontalProductListWidget(),
          _titleWidget("热门推荐"),
          _recProductListWidget(),
        ],
      ),
    );
  }
}
