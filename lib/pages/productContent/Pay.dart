import 'package:flutter/material.dart';
import 'package:jdshop_app/widget/JDButton.dart';

class PayPage extends StatefulWidget {
  PayPage({Key key}) : super(key: key);

  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  List payList = [
    {
      "title": "支付宝支付",
      "chekced": true,
      "image": "https://www.itying.com/themes/itying/images/alipay.png"
    },
    {
      "title": "微信支付",
      "chekced": false,
      "image": "https://www.itying.com/themes/itying/images/weixinpay.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("去支付"),
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 400,
              padding: EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: this.payList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Image.network("${this.payList[index]["image"]}"),
                        title: Text("${this.payList[index]["title"]}"),
                        trailing: this.payList[index]["chekced"] ? Icon(Icons.check) : Text(""),


                        onTap: () {
                          setState(() {
                            //让payList里面的checked都等于false
                            for (var i = 0; i < this.payList.length; i++) {
                              this.payList[i]['chekced'] = false;
                            }
                            // 当前选中的true
                            this.payList[index]["chekced"] = true;
                          });
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              )),
          JDButton(
            buttonTitle: "支付",
            buttonColor: Colors.red,
            height: 74,
            tapEvent: () {
              print('支付1111');
            },
          )
        ],
      ),
    );
  }
}
