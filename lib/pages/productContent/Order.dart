import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/model/OrderModel.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/SignServices.dart';
import 'package:jdshop_app/services/UserServices.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  // 获取数据
  List _orderList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getListData();
  }
  void _getListData() async {
    List userinfo = await UserServices.getUserInfo();
    var tempJson = {"uid": userinfo[0]['_id'], "salt": userinfo[0]["salt"]};
    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/orderList?uid=${userinfo[0]['_id']}&sign=${sign}';
    var response = await Dio().get(api);
    print(response.data is Map);
    setState(() {
      var orderMode = new OrderModel.fromJson(response.data);
      this._orderList = orderMode.result;
      print(this._orderList[0].name);
    });
  }

  //自定义商品列表组件
  List<Widget> _orderItemWidget(orderItems) {
    List<Widget> tempList = [];
    for (var i = 0; i < orderItems.length; i++) {
      tempList.add(Column(
        children: <Widget>[
          SizedBox(height: 10),
          ListTile(
            leading: Container(
              width: ScreenAdaper.width(120),
              height: ScreenAdaper.height(120),
              child: Image.network(
                '${orderItems[i].productImg}',
                fit: BoxFit.cover,
              ),
            ),
            title: Text("${orderItems[i].productTitle}"),
            trailing: Text('x${orderItems[i].productCount}'),
          ),
          SizedBox(height: 10)
        ],
      ));
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的订单"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, ScreenAdaper.height(80), 0, 0),
            padding: EdgeInsets.all(ScreenAdaper.width(16)),
            child: ListView(
                children: this._orderList.map((value) {
                  return InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/orderinfo');
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text("订单编号：${value.sId}",
                                style: TextStyle(color: Colors.black54)),
                          ),
                          Divider(),
                          Column(
                            children: this._orderItemWidget(value.orderItem),
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Text("合计：￥${value.allPrice}"),
                            trailing: FlatButton(
                              child: Text("申请售后"),
                              onPressed: () {},
                              color: Colors.grey[100],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()),
          ),
          Positioned(
            top: 0,
            width: ScreenAdaper.width(750),
            height: ScreenAdaper.height(76),
            child: Container(
              width: ScreenAdaper.width(750),
              height: ScreenAdaper.height(76),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("全部", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("待付款", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("待收货", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("已完成", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("已取消", textAlign: TextAlign.center),
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
