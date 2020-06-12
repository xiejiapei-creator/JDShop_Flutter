import 'package:flutter/material.dart';
import 'package:jdshop_app/provider/CartProvider.dart';
import 'package:jdshop_app/provider/CheckOutProvider.dart';
import 'package:jdshop_app/routers/router.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // 提供通知
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CheckOutProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],

      child: MaterialApp(
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
          // 修改主题颜色
          theme: ThemeData(
              primaryColor: Colors.white
          ),
          // 去掉debug
          debugShowCheckedModeBanner: false
      )
    );
  }
}
