import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jdshop_app/config/Config.dart';
import 'package:jdshop_app/services/EventsBus.dart';
import 'package:jdshop_app/services/ScreenAdaper.dart';
import 'package:jdshop_app/services/SignServices.dart';
import 'package:jdshop_app/services/UserServices.dart';
import 'package:jdshop_app/widget/JDButton.dart';
import 'package:jdshop_app/widget/JDText.dart';

class AddressEditPage extends StatefulWidget {
  Map arguments;
  AddressEditPage({Key key,this.arguments}) : super(key: key);

  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  String area='';
  // 初始化的时候给编辑页面赋值
  TextEditingController nameController=new TextEditingController();
  TextEditingController phoneController=new TextEditingController();
  TextEditingController addressController=new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.text = widget.arguments['name'];
    phoneController.text = widget.arguments['phone'];
    addressController.text = widget.arguments['address'];
  }

  //监听页面销毁的事件
  dispose(){
    super.dispose();
    eventBus.fire(new AddressEvent('编辑成功...'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("修改收货地址"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[

              SizedBox(height: 20),
              JdText(
                controller: nameController,
                text: "收货人姓名",
                onChanged: (value){
                  nameController.text = value;
                },
              ),
              SizedBox(height: 10),
              JdText(
                controller: phoneController,
                text: "收货人电话",
                onChanged: (value){
                  phoneController.text = value;
                },
              ),

              // 地址
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 5),
                height: ScreenAdaper.height(68),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black12))),
                child: InkWell(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_location),
                      this.area.length>0?Text('${this.area}', style: TextStyle(color: Colors.black54)):Text('省/市/区', style: TextStyle(color: Colors.black54))
                    ],
                  ),
                  onTap: () async{
                    Result result = await CityPickers.showCityPicker(
                        context: context,
                        // 可以直接定位
                        // locationCode: "130102",
                        cancelWidget:
                        Text("取消", style: TextStyle(color: Colors.blue)),
                        confirmWidget:
                        Text("确定", style: TextStyle(color: Colors.blue))
                    );
                    setState(() {
                      this.area= "${result.provinceName}/${result.cityName}/${result.areaName}";
                    });
                  },
                ),
              ),

              SizedBox(height: 10),
              JdText(
                controller: addressController,
                text: "详细地址",
                maxLines: 4,
                height: 200,
                onChanged: (value){
                  addressController.text = value;
                },
              ),
              SizedBox(height: 40),

              // 修改
              JDButton(buttonTitle: "修改", buttonColor: Colors.red,tapEvent: () async{
                List userinfo=await UserServices.getUserInfo();
                var tempJson={
                  "uid":userinfo[0]["_id"],
                  "id":widget.arguments["id"],
                  "name": nameController.text,
                  "phone":phoneController.text,
                  "address":addressController.text,
                  "salt":userinfo[0]["salt"]
                };
                var sign = SignServices.getSign(tempJson);
                var api = '${Config.domain}api/editAddress';
                var response = await Dio().post(api,data:{
                  "uid":userinfo[0]["_id"],
                  "id":widget.arguments["id"],
                  "name": nameController.text,
                  "phone":phoneController.text,
                  "address":addressController.text,
                  "sign":sign
                });
                Navigator.pop(context);
              })
            ],
          ),
        )
    );
  }
}