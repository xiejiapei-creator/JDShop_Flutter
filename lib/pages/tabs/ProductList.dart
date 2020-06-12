import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/model/ProductList.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/SearchServices.dart';
import 'package:jdshop_app/widget/LoadingWidget.dart';

class ProductListPage extends StatefulWidget {
  // 上个页面传入arguments参数
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  //是否有搜索的数据
  bool _hasData = true;

  //cid
  var _cid;
  //keywords
  var _keywords;

  // 配置search搜索框的值
  var _initKeywordsController= new TextEditingController();


  // 二级导航数据
  List _subHeaderList = [
    {
      "id": 1,
      "title": "综合",
      "fileds": "all",
      "sort":
      -1, //排序     升序：price_1     {price:1}        降序：price_-1   {price:-1}
    },
    {"id": 2, "title": "销量", "fileds": 'salecount', "sort": -1},
    {"id": 3, "title": "价格", "fileds": 'price', "sort": -1},
    {"id": 4, "title": "筛选"}
  ];

  //二级导航选中判断
  int _selectHeaderId = 1;

  //导航改变的时候触发
  _subHeaderChange(id) {
    if (id == 4) {
      // 打开侧边栏
      _scaffoldKey.currentState.openEndDrawer();
      setState(() {
        this._selectHeaderId = id;
      });
    } else {// 更改选中颜色
      setState(() {
        this._selectHeaderId = id;
        // 改变排序方式:id-1在数组中为0
        this._sort = "${this._subHeaderList[id-1]["fileds"]}_${this._subHeaderList[id-1]["sort"]}";
        // 重置分页数为1
        this._page = 1;
        // 清空旧数据列表
        this._productList = [];
        // 回到顶部位置
        _scrollController.jumpTo(0);
        // 在价格中拉到最底部hasmore为false,在销量时候就会只请求一页,需要重置
        this._hasMore = true;
        // 再次点击，排序方式相反，从降序变为升序
        this._subHeaderList[id-1]["sort"] = -this._subHeaderList[id-1]["sort"];
        // 重新请求数据
        _getProductListData();
      });
    }
  }

  //显示header Icon
  Widget _showIcon(id) {
    if (id == 2 || id == 3) {
      return Icon((this._selectHeaderId == id ? Icons.arrow_drop_down : Icons.arrow_drop_up));
    }
    else {
      return Text("");
    }
  }

  // 通过事件打开侧边栏
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // 用于上拉分页
  ScrollController _scrollController = ScrollController(); //listview 的控制器

  // 解决重复请求的问题
  bool _flag = true;

  // 每页有多少条数据: 服务器默认每次返回10条
  int _pageSize = 8;

  //  是否有数据
  bool _hasMore = true;

  // 商品列表 Model
  int _page = 1;// 分页
  // 排序:价格升序 sort=price_1 价格降序 sort=price_-1  销量升序 sort=salecount_1 销量降序 sort=salecount_-1
  String _sort = "";
  List _productList = [];

  _getProductListData() async {
    // 防止下拉加载请求未完成时候再去第二次重复请求
    setState(() {
      this._flag = false;
    });
    // 判断是搜索传入还是分类传入
    var api;
    if (this._keywords == null) {
      api = "${Config.domain}api/plist?cid=${this._cid}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}";
    } else {
      // api = "${Config.domain}api/plist?search=${this._keywords}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}";
      api = "${Config.domain}api/plist?search=${this._initKeywordsController.text}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}";
    }
    var result = await Dio().get(api);
    var productList = new ProductListModel.fromJson(result.data);

    // 判断是否有搜索的数据: 第一页，防止最后一页数据为0时也造成无数据假象
    if (productList.result.length > 0 && this._page == 1) {
      setState(() {
        this._hasData = true;
      });
    } else {
      setState(() {
        this._hasData = false;
      });
    }

    // 判断最后一页有没有数据
    if (productList.result.length < this._pageSize) { // 下一页就没数据了
      setState(() {
        this._productList.addAll(productList.result);
        this._hasMore = false;
        // 请求已经完成
        this._flag = true;
      });
    } else {
      setState(() {
        // 拼接数据不是替换
        // this._productList = _productList.result;
        this._productList.addAll(productList.result);
        this._page++;
        // 请求已经完成
        this._flag = true;
      });
    }
  }

  // 显示加载中的圈圈
  Widget _showMore(index) {
    if (this._hasMore) {
      return (index == this._productList.length - 1) ? LoadingWidget() : Text("");

    } else {
      return (index == this._productList.length - 1) ?Text("--我是有底线的--"): Text("");

    }
  }

  // 商品列表 UI
  Widget _productListWidget() {
    if (this._productList.length > 0) {
      return Container(// 列表容器
        padding: EdgeInsets.all(10),
        // 距离筛选栏距离80
        margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
        child: ListView.builder(// 列表循环
            controller: _scrollController,// 下拉刷新
            itemCount: this._productList.length,
            itemBuilder: (context, index) {
              // 获得小图
              String sPic = this._productList[index].pic;
              sPic = Config.domain + sPic.replaceAll('\\', '/');

              return Column(// 上Item下分割线
                children: <Widget>[
                  Row(// 左固定宽度，右自适应宽度
                    children: <Widget>[
                      Container(
                        width: ScreenAdaper.width(180),
                        height: ScreenAdaper.height(180),
                        child: Image.network("${sPic}",fit: BoxFit.cover),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenAdaper.width(180),
                          // 与左侧图片相距10
                          margin: EdgeInsets.only(left: 10),
                          child: Column(// 上标题下价格
                            // 上下 必须先设置高度 元素之间距离和距离边境距离相等(spaceEvenly) 元素之间距离相等，但是最外边两个元素居于顶格（spaceBetween）
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // 水平居左
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${this._productList[index].title}",maxLines: 2,overflow: TextOverflow.ellipsis),

                              // 中间盒子
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: ScreenAdaper.height(36),
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                    //注意 如果Container里面加上decoration属性，这个时候color属性必须得放在BoxDecoration
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 230, 230, 0.9),
                                    ),

                                    child: Text("4g"),
                                  ),
                                  Container(
                                    height: ScreenAdaper.height(36),
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 230, 230, 0.9),
                                    ),
                                    child: Text("126"),
                                  ),
                                ],
                              ),

                              Text("¥${this._productList[index].price}",style: TextStyle(color: Colors.red, fontSize: 16))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  // 是否加载到无更多数据
                  _showMore(index)
                ],
              );
            }
        ),
      );
    }
    else {
      // 加载中
      return LoadingWidget();
    }
  }

  // 筛选导航
  Widget _subHeaderWidget() {
    return             Positioned(// 放在下面可以位于最顶层，盖住列表
      top: 0,//位于顶部
      width: ScreenAdaper.width(750),
      height: ScreenAdaper.height(80),
      child: Container(
        width: ScreenAdaper.width(750),
        height: ScreenAdaper.height(80),
        decoration: BoxDecoration(// 底部线条
            border: Border(
                bottom: BorderSide(
                    width: 1,
                    color: Colors.black54
                )
            )
        ),
        child: Row(// 多个元素从左到右
          children: this._subHeaderList.map((value){// 循环遍历数组
            return Expanded(// 需要用到自适应布局
              flex:1,
              child: InkWell(// 按钮支持点击
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(20), 0, ScreenAdaper.height(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${value["title"]}",textAlign: TextAlign.center, style: TextStyle(color: (this._selectHeaderId == value["id"] ? Colors.red : Colors.black54))),
                        // 添加选中箭头
                        _showIcon(value["id"])
                      ],
                    )
                ),
                onTap: (){
                  _subHeaderChange(value["id"]);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 给search框框赋值
    // 必须放在 第一次请求数据 上门，先赋值再请求
    this._cid = widget.arguments["cid"];
    this._keywords = widget.arguments["keywords"];
    this._initKeywordsController.text =  this._keywords == null ? "" : this._keywords;

    // 第一次请求数据
    _getProductListData();

    //监听滚动条滚动事件
    _scrollController.addListener((){
      //获取滚动条滚动的高度 pixels
      //获取页面高度 maxScrollExtent
      //二者相等表示拉到底部, -20表示距离底部20的时候即下拉加载更多
      // 防止下拉加载请求未完成时候再去第二次重复请求
      // 加载到底部没有更多数据
      if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 20 && this._flag == true && this._hasMore == true) {
        _getProductListData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 计算适配
    ScreenAdaper.init(context);

    return Scaffold(
      // Scaffold 用于唯一ID
        key: _scaffoldKey,
//        appBar: AppBar(
//          title: Text("商品列表"),
//          // 去掉左边文本来去掉左边抽屉
//          // leading: Text(""),
//          // 去掉右边文本来去掉右边抽屉
//          actions: <Widget>[
//            Text("")
//          ],
//        ),
        appBar: AppBar(// 商品列表页面也可以搜索
          title: Container(
            padding: EdgeInsets.only(bottom: 10),
            height: ScreenAdaper.height(60),
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(30)),
            child: TextField(
              // 搜索界面进来，文本框有带入值
              controller: this._initKeywordsController,
              // 进来商品列表不需要默认选中，键盘弹出
              autofocus: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    // 去掉TextField边框
                      borderSide: BorderSide.none,
                      // 圆角和外层一样
                      borderRadius: BorderRadius.circular(30))),
              onChanged: (value) {// 获得输入的内容
                setState(() {
                  this._keywords = value;
                });
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
                // 本地存储历史记录
                SearchServices.setHistoryData(this._keywords);

                // 重新请求数据接口
                // 默认综合排序
                this._subHeaderChange(1);
              },
            )
          ],
        ),
        endDrawer: Drawer(
          child: Container(
            child: Text("商品列表商品列表商品列表商品列表商品列表商品列表商品列表商品列表商品列表商品列表商品列表"),
          ),
        ),
        // 直接获取父类的属性值
        body: this._hasData ? Stack(// 顶部导航下面排序列表
          children: <Widget>[
            _productListWidget(),
            _subHeaderWidget()
          ],
        ) : Center(
          child: Text("无搜索结果"),
        )
    );
  }
}

