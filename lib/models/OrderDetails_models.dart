class OrderDetailsModel {
  double? total;
  int? invid;
  String? description;
  double? discount;
  int? qtysold;
  double? rprice;
  double? subtotal;
  double? vattotal;

  OrderDetailsModel(
      {this.invid,
      this.description,
      this.discount,
      this.qtysold,
      this.rprice,
      this.total,
      this.subtotal,
      this.vattotal});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    invid = json['invid'];
    total = (json['total'] as num).toDouble();
    description = json['description'];
    discount = (json['discount'] as num).toDouble();
    rprice = (json['rprice'] as num).toDouble();
    qtysold = json['qtysold'];
    subtotal = (json['subtotal'] as num).toDouble();
    vattotal = (json['vattotal'] as num).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invid'] = this.invid;
    data['total'] = this.total;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['rprice'] = this.rprice;
    data['qtysold'] = this.qtysold;

    return data;
  }
}
