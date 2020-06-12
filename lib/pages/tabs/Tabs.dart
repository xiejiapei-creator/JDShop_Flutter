import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jdshop_app/pages/tabs/Cart.dart';
import 'package:jdshop_app/pages/tabs/Category.dart';
import 'package:jdshop_app/pages/tabs/Home.dart';
import 'package:jdshop_app/pages/tabs/User.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  // 默认加载分类页面
  int _currentIndex = 0;

  List<Widget> _pageList = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage(),
  ];

  // 部分页面缓存部分页面重新加载
  var _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 初始化
    this._pageController = new PageController(initialPage: this._currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return Scaffold(

      //body: this._pageList[this._currentIndex],
      /*
      //优点：层叠组件，切换TAB时候不用重新请求接口,实现状态保持,不会重新刷新页面
      //缺点：刚开始一次性加载四个页面，根据_currentIndex决定显示哪个, 所以切换到购物车时候不会重新请求刷新数据
      body: IndexedStack(
        index: this._currentIndex,
        children: this._pageList
      ),
      */
      // 部分页面缓存部分页面重新加载
      body: PageView(// 实现页面加载
        controller: this._pageController,
        children: this._pageList,
        onPageChanged: (index){// 手左右滑动的索引值
          // 让底部Tab也对应选中
          setState(() {
            this._currentIndex = index;
          });
        },
        // 禁止手左右滑动
        // physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (index) {
          setState(() {
            this._currentIndex = index;
            // 实现页面切换
            this._pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("首页")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.category),
              title: Text("分类")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text("购物车")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text("我的")
          )
        ],
      ),
    );
  }
}
