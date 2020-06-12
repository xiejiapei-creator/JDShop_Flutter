import 'package:flutter/material.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class ProductContentDetailPage extends StatefulWidget {
  final List _productContentList;
  ProductContentDetailPage(this._productContentList, {Key key}) : super(key: key);

  @override
  _ProductContentDetailPageState createState() => _ProductContentDetailPageState();
}

class _ProductContentDetailPageState extends State<ProductContentDetailPage> with AutomaticKeepAliveClientMixin {

  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  var _id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 传入详情ID
    this._id = widget._productContentList[0].sId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: InAppWebView(
                initialUrl: "http://jd.itying.com/pcontent?id=${this._id}",
                initialHeaders: {},

                initialOptions: InAppWebViewWidgetOptions(
                    inAppWebViewOptions: InAppWebViewOptions(
                      debuggingEnabled: true,
                    )
                ),

                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  setState(() {
                    this.url = url;
                  });
                },
                onLoadStop: (InAppWebViewController controller, String url) async {
                  setState(() {
                    this.url = url;
                  });
                },
                onProgressChanged: (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ),
        ])
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
