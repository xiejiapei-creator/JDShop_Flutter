class ProductListModel {
  List<ProductListItemModel> result;

  ProductListModel({this.result});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<ProductListItemModel>();
      json['result'].forEach((v) {
        result.add(new ProductListItemModel.fromJson(v));
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

class ProductListItemModel {
  String sId;
  String title;
  String cid;
  Object price;
  String oldPrice;
  String pic;
  // 自动会 去掉下划线，以驼峰形式命名
  String sPic;

  ProductListItemModel(
      {this.sId,
        this.title,
        this.cid,
        this.price,
        this.oldPrice,
        this.pic,
        this.sPic});

  ProductListItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    cid = json['cid'];
    price = json['price'];
    oldPrice = json['old_price'];
    pic = json['pic'];
    sPic = json['s_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['cid'] = this.cid;
    data['price'] = this.price;
    data['old_price'] = this.oldPrice;
    data['pic'] = this.pic;
    data['s_pic'] = this.sPic;
    return data;
  }
}