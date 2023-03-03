import 'package:json_annotation/json_annotation.dart';

part 'inventorymodels.g.dart';

@JsonSerializable()
class InventoryItem {
  int? id;
  String? description;
  String? invCode;
  int? vat;
  double? rprice;
  double? itemQty;
  String? remarks;

  InventoryItem(
      {this.id,
      this.description,
      this.invCode,
        this.itemQty,
      this.vat,
      this.rprice,
      this.remarks});

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);

  @override
  String toString() {
    return 'InventoryItem{id: $id, description: $description, invCode: $invCode, vat: $vat, rprice: $rprice,itemQty:$itemQty}';
  }
}

@JsonSerializable()
class InvClass {
  int? id;
  String? description;

  InvClass({this.id, this.description});

  factory InvClass.fromJson(Map<String, dynamic> json) =>
      _$InvClassFromJson(json);
  Map<String, dynamic> toJson() => _$InvClassToJson(this);

  @override
  String toString() {
    return 'InvClass{id: $id, description: $description}';
  }
}

@JsonSerializable()
class PriceListDetail {
  int? id;
  int? pricelist;
  int? inventory;
  double? sellingprice;
  double? discount;

  PriceListDetail(
      {this.id,
      this.pricelist,
      this.inventory,
      this.sellingprice,
      this.discount});

  factory PriceListDetail.fromJson(Map<String, dynamic> json) =>
      _$PriceListDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PriceListDetailToJson(this);

  @override
  String toString() {
    return 'PriceListDetail{id: $id, pricelist: $pricelist, inventory: $inventory, sellingprice: $sellingprice, discount: $discount}';
  }
}

@JsonSerializable()
class MReqDetail {
  int? invid;
  String? desc;
  double? qty;
  double? rprice;
  double? itemQty;
  double? total;
  String? remarks;

  MReqDetail(
      {this.invid,
      this.desc,
      this.rprice,
      this.itemQty,
      this.qty,
      this.total,
      this.remarks});
  factory MReqDetail.fromJson(Map<String, dynamic> json) =>
      _$MReqDetailFromJson(json);
  Map<String, dynamic> toJson() => _$MReqDetailToJson(this);

  @override
  String toString() {
    return 'MReqDetail{invid: $invid, qty: $qty}';
  }
}

@JsonSerializable(explicitToJson: true)
class MReqObject {
  int? costcenter;
  String? remarks;
  List<MReqDetail>? reqDetails;

  MReqObject({this.costcenter, this.remarks, this.reqDetails});
  factory MReqObject.fromJson(Map<String, dynamic> json) =>
      _$MReqObjectFromJson(json);
  Map<String, dynamic> toJson() => _$MReqObjectToJson(this);

  @override
  String toString() {
    return 'MReqObject{costcenter: $costcenter, remarks: $remarks, reqDetails: $reqDetails}';
  }
}
