import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/model/CateModel.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin {

  // 缓存当前页面
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // 左边选中的颜色
  int _selectIndex = 0;

  // 左侧组件 Model
  List _leftCateList = [];
  _getLeftCateData() async {
    var api = "${Config.domain}api/pcate";
    var result = await Dio().get(api);
    var leftCateList = new CateModel.fromJson(result.data);
    setState(() {
      this._leftCateList = leftCateList.result;
    });
    // 请求完左侧后请求默认选中的右侧数据
    _getRightCateData(leftCateList.result[0].sId);
  }

  // 左侧组件 UI
  Widget _leftCateWidget(leftWidth) {
    if (_leftCateList.length > 0) {
      return Container(// 左边大容器:固定宽度
        width: leftWidth,
        // 高度自适应屏幕
        height: double.infinity,
        color: Colors.white,
        child: ListView.builder(// 支持滑动，数据动态生成
          itemCount: this._leftCateList.length,
          itemBuilder: (context,index){
            return Column(// 上文本下线条
              children: <Widget>[
                InkWell(// 文本支持点击事件
                  onTap: (){
                    setState(() {
                      // 点击切换左侧颜色
                      _selectIndex = index;
                      // 点击切换右侧界面
                      _getRightCateData(this._leftCateList[index].sId);
                    });
                  },
                  child: Container(// 文本框设置背景颜色宽高等
                    child: Text("${this._leftCateList[index].title}",textAlign: TextAlign.center,),
                    width: double.infinity,
                    height: ScreenAdaper.height(84),
                    padding: EdgeInsets.only(top: ScreenAdaper.height(24)),
                    color: _selectIndex == index ? Color.fromRGBO(240, 240, 240, 0.9) : Colors.white,
                  ),
                ),
                Divider(height: 1)// 线条有默认高度16，造成间隙，需要设置为1
              ],
            );
          },
        ),
      );
    } else {
      return Container(// 不能返回空字符串，必须返回容器，防止错位，右侧铺满屏幕
        width: leftWidth,
        height: double.infinity,
      );
    }
  }

  // 右侧组件 Model
  List _rightCateList = [];
  _getRightCateData(pid) async {
    var api = "${Config.domain}api/pcate?pid=${pid}";
    var result = await Dio().get(api);
    var rightCateList = new CateModel.fromJson(result.data);
    setState(() {
      this._rightCateList = rightCateList.result;
    });
  }

  // 右侧组件 UI
  Widget _rightCateWidget(rightItemWidth, rightItemHeight) {
    if (_rightCateList.length > 0) {
      return Expanded(// 右侧自适应宽度
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 240, 240, 0.9),
            child: GridView.builder(// 动态GridView
              itemCount: this._rightCateList.length,
              itemBuilder: (context,index){

                // 获得小图
                String sPic = this._rightCateList[index].pic;
                sPic = Config.domain + sPic.replaceAll('\\', '/');

                return InkWell(// 支持点击Container进行跳转
                  onTap: (){// 跳转传值
                    Navigator.pushNamed(context, '/productList',arguments:{
                      "cid" : this._rightCateList[index].sId
                    });
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        // 图片
                        AspectRatio(
                          aspectRatio: 1/1,
                          child: Image.network("${sPic}",fit: BoxFit.cover,),
                        ),

                        // 文本
                        Container(
                          height: ScreenAdaper.height(28),
                          child: Text("${this._rightCateList[index].title}"),
                        )
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // 配置每一行的数量、宽高比、间距
                  crossAxisCount: 3,
                  // Item宽高比，适配不同设备
                  childAspectRatio: rightItemWidth/rightItemHeight,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10
              ),
            )
        ),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          color: Color.fromRGBO(240, 246, 246, 0.9),
          child: Text("加载中..."),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("商品分类");

    _getLeftCateData();
  }

  @override
  Widget build(BuildContext context) {
    // 使用ScreenAdaper之前需要init
    ScreenAdaper.init(context);

    //计算右侧GridView宽高比
    //左侧宽度 = 屏幕四分之一
    var leftWidth = ScreenAdaper.getScreenWidth()/4;
    //右侧每一项宽度 =（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3
    //Padding Spacing 会均匀分配，方便计算，可直接设为10
    var rightItemWidth = (ScreenAdaper.getScreenWidth() - leftWidth - 20 - 20)/3;
    //获取计算后的宽度    
    rightItemWidth = ScreenAdaper.width(rightItemWidth);
    //右侧每一项高度 = 1:1图片宽度 + 文本高度
    var rightItemHeight = rightItemWidth + ScreenAdaper.height(28);

    return Scaffold(
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
      body: Row(// 左右两栏，每栏为列
        children: <Widget>[
          _leftCateWidget(leftWidth),
          _rightCateWidget(rightItemWidth, rightItemHeight)
        ],
      ),
    );

  }
}