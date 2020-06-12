import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

// 购物车广播
class ProductContentEvent {
  String str;
  ProductContentEvent(String str) {
    this.str = str;
  }
}

// 用户中心广播
class UserEvent {
  String str;
  UserEvent(String str) {
    this.str = str;
  }
}

// 增加地址广播
class AddressEvent {
  String str;
  AddressEvent(String str) {
    this.str = str;
  }
}

// 默认地址广播
class DefaultAddressEvent {
  String str;
  DefaultAddressEvent(String str) {
    this.str = str;
  }
}