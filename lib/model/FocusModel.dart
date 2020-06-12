// '{"_id":"59f6ef443ce1fb0fb02c7a43","title":"笔记本电脑 ","status":"1","pic":"public\\upload\\UObZahqPYzFvx_C9CQjU8KiX.png"," url":"12" }'
// 小项目中使用 dart:convert 手动序列化 JSON 非常好
// 大项目类型安全（20看不出int还是string、自动补全people.name而不是people["name"]
// 最重要的编译时异常people["neme"]打错不能发现，编译了才能发现

class FocusModel {
  List<FocusItem> result;

  FocusModel({this.result});

  FocusModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<FocusItem>();
      json['result'].forEach((v) {
        result.add(new FocusItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FocusItem {
  String sId;// 商品id
  String title;// 标题
  String status;
  String pic;// 图片地址
  String url;// 跳转地址

  // 可选构造函数
  FocusItem({this.sId, this.title, this.status, this.pic, this.url});

  // 命名构造函数
  FocusItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    status = json['status'];
    pic = json['pic'];
    url = json['url'];
  }

  // 类里面的属性转化为Map类型
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['status'] = this.status;
    data['pic'] = this.pic;
    data['url'] = this.url;
    return data;
  }
}