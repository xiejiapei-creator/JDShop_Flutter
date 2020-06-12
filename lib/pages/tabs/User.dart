import 'package:flutter/material.dart';
import 'package:jdshop_app/provider/CartProvider.dart';
import 'package:jdshop_app/services/EventsBus.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/UserServices.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  // 判断用户是否登陆
  bool _isLogin = false;
  List _userInfo = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getUserInfo();

    // 监听登陆界面的广播事件
    eventBus.on<UserEvent>().listen((event){
      print("object");
      print(event.str);
      // 重新获取用户信息，因为不会子页面返回不会触发init
      this._getUserInfo();
    });
  }
  _getUserInfo() async {
    var isLogin = await UserServices.getUserState();
    var userInfo = await UserServices.getUserInfo();
    setState(() {
      this._userInfo = userInfo;
      this._isLogin = isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取通知提供的值: 全选按钮

    var counterProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      // 操作列表: ListView当太多操作的时候支持滑动
      body: ListView(
        children: <Widget>[
          Container(
            height: ScreenAdaper.height(220),
            width: double.infinity,
            // 背景图片
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/user_bg.jpg"),
                fit: BoxFit.cover
              )
            ),
            child: Row(
              children: <Widget>[
                // 头像
                Container(// 可以给左右来点间距
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ClipOval( 
                    // child: Image.asset('images/user.png',fit: BoxFit.cover,width: ScreenAdaper.width(100),height: ScreenAdaper.height(100)),
                    child: Image.network("http://i0.hdslb.com/bfs/article/0d3f17d197577d794d70a8dc874d4f0b92fe795c.jpg",fit: BoxFit.cover,width: ScreenAdaper.width(100),height: ScreenAdaper.height(100)),
                  ),
                ),

                this._isLogin ? Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("用户名：${this._userInfo[0]["username"]}", style: TextStyle(color: Colors.white, fontSize: ScreenAdaper.fontSize(32))),
                      Text("普通会员", style: TextStyle( color: Colors.white, fontSize: ScreenAdaper.fontSize(24))),
                    ],
                  ),
                ) : Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text("登陆/注册", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.assignment, color: Colors.red),
            title: Text("全部订单"),
            onTap: () {
              Navigator.pushNamed(context, "/order");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.green),
            title: Text("待付款"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_car_wash, color: Colors.orange),
            title: Text("待收货"),
          ),
          Container(
              width: double.infinity,
              height: 10,
              color: Color.fromRGBO(242, 242, 242, 0.9)),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.lightGreen),
            title: Text("我的收藏"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people, color: Colors.black54),
            title: Text("在线客服"),
          ),
          Divider(),

          // 退出登陆
          this._isLogin ? JDButton(
            buttonTitle: "退出登陆",
            buttonColor: Colors.red,
            tapEvent: () {
              UserServices.loginOut();
              this._getUserInfo();
            },
          ) : Text("")
        ],
      ),
    );
  }
}