import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/SearchServices.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // 删除提示
  _showAlertDialog(keywords) async {
    var result = await showDialog<void>(
      context: context,
      // 表示点击灰色背景的时候是否消失弹出框
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('提示信息!'),
          content: Text('您确定要删除吗?'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            FlatButton(
              child: Text("确定"),
              onPressed: () async {
                // 注意异步: 长按删除某条历史记录
                await SearchServices.removeHistoryData(keywords);
                // 刷新页面
                this._getHistoryListData();
                Navigator.pop(context, "Ok");
              },
            )
          ],
        );
      },
    );
  }

  // 热搜数据
  List _hotSearchListData = ["女装", "笔记本", "手机", "旅游背包", "冬季毛衣", "帆布鞋", "饭盒"];
  // 热搜 UI
  Widget _hotSearchList() {
    if (this._hotSearchListData.length > 0) {
      return Wrap(
          // 内容超出的可以换行
          children: this._hotSearchListData.map((value) {
        return InkWell(
          child: Container(
            // 用户搜索的长度不一样，根据文字来，不能给Container设置长度
            padding: EdgeInsets.all(10), // 内边距
            margin: EdgeInsets.all(10), // 外边距
            decoration: BoxDecoration(
                // 圆角
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(233, 233, 233, 0.8)),
            child: Text("${value}"),
          ),
          onTap: () {
            this._keywords = value;
            // 保持历史搜索记录
            SearchServices.setHistoryData(this._keywords);

            // 跳转到商品列表页面, 传入搜索值
            // 商品列表直接返回到首页，而不是搜索页面
            Navigator.pushReplacementNamed(context, '/productList',
                arguments: {"keywords": this._keywords});
          },
        );
      }).toList());
    } else {
      return Text("");
    }
  }

  // 用户输入的值
  var _keywords;

  // 获取历史搜索记录列表 Model
  List _historyListData = [];
  _getHistoryListData() async {
    var _historyListData = await SearchServices.getHistoryData();
    setState(() {
      this._historyListData = _historyListData;
    });
  }

  // 获取历史搜索记录列表 UI
  Widget _historyListWidget() {
    if (this._historyListData.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("历史记录", style: Theme.of(context).textTheme.title),
          ),
          Divider(),
          Column(
              // 循环遍历列表
              children: this._historyListData.map((value) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text("${value}"),
                  onLongPress: () {
                    // 长按删除
                    this._showAlertDialog(value);
                  },
                  onTap: (){
                    this._keywords = value;
                    // 保持历史搜索记录
                    SearchServices.setHistoryData(this._keywords);

                    // 跳转到商品列表页面, 传入搜索值
                    // 商品列表直接返回到首页，而不是搜索页面
                    Navigator.pushReplacementNamed(context, '/productList',
                        arguments: {"keywords": this._keywords});
                  },
                ),
                Divider()
              ],
            );
          }).toList()),
          SizedBox(height: 100),
          Row(
            // 让清空历史记录按钮居中
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                // 点击按钮
                child: Container(
                    width: ScreenAdaper.width(400),
                    height: ScreenAdaper.height(64),
                    decoration: BoxDecoration(
                        // 边框
                        border: Border.all(color: Colors.black45, width: 1)),
                    child: Row(
                      // 左删除图标右清空按钮
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Icon(Icons.delete), Text("清空历史记录")],
                    )),
                onTap: () {
                  // 清空本地缓存历史记录
                  SearchServices.clearHistoryList();
                  // 重新渲染页面
                  _getHistoryListData();
                },
              )
            ],
          )
        ],
      );
    } else {
      return Text("");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 获取历史记录数据
    _getHistoryListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: ScreenAdaper.height(60),
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(bottom: 10),
            child: TextField(
              // 进来默认选中，键盘弹出
              autofocus: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      // 去掉TextField边框
                      borderSide: BorderSide.none,
                      // 圆角和外层一样
                      borderRadius: BorderRadius.circular(30))),
              onChanged: (value) {
                // 获得输入的内容
                this._keywords = value;
              },
            ),
          ),
          actions: <Widget>[
            // 点击搜索按钮
            InkWell(
              child: Container(
                // 容器
                height: ScreenAdaper.height(70),
                width: ScreenAdaper.width(80),
                child: Row(
                  // 居中
                  children: <Widget>[
                    Text('搜索'),
                  ],
                ),
              ),
              onTap: () {
                // 保持历史搜索记录
                SearchServices.setHistoryData(this._keywords);

                // 跳转到商品列表页面, 传入搜索值
                // 商品列表直接返回到首页，而不是搜索页面
                Navigator.pushReplacementNamed(context, '/productList',
                    arguments: {"keywords": this._keywords});
              },
            )
          ],
        ),
        body: Padding(
            // 和四周有间距
            padding: EdgeInsets.all(10),
            child: ListView(
              // 当搜索记录过多时候，支持下拉
              children: <Widget>[
                Container(
                  // 主题样式
                  child: Text("热搜", style: Theme.of(context).textTheme.title),
                ),
                Divider(),
                // 热搜
                _hotSearchList(),
                // 添加间距
                SizedBox(height: 10),
                // 历史记录列表
                _historyListWidget(),
              ],
            )));
  }
}
