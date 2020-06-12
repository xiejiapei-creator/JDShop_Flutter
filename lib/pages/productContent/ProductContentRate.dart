import 'package:flutter/material.dart';

class ProductContentRatePage extends StatefulWidget {
  @override
  _ProductContentRatePageState createState() => _ProductContentRatePageState();
}

class _ProductContentRatePageState extends State<ProductContentRatePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 30,
        itemBuilder: (context,index) {
          return ListTile(
            title: Text("第${index}条数据"),
          );
        },
      ),
    );
  }
}
