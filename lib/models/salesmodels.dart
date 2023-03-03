import 'package:json_annotation/json_annotation.dart';
import 'package:posapp/utils/config.dart' as config;

part 'salesmodels.g.dart';

@JsonSerializable()
class Vat {
  int? id;
  String? code;
  double? rate;

  Vat({this.id, this.code, this.rate});
  factory Vat.fromJson(Map<String, dynamic> json) => _$VatFromJson(json);
  Map<String, dynamic> toJson() => _$VatToJson(this);

  @override
  String toString() {
    return 'Vat{id: $id, code: $code, rate: $rate}';
  }
}

@JsonSerializable()
class OrderDetail {
  String? latitude;
  String? longitude;
  String? invCode;
  String? invDescrip;
  double? invQty;
  double? itemPrice;
  double? itemQty;
  double? originalPrice;
  double? invDiscount;
  double? invPrice;

  OrderDetail(
      {this.latitude,
      this.longitude,
      this.invCode,
      this.originalPrice,
      this.invDescrip,
      this.invQty,
      this.invDiscount,
      this.itemQty,
      this.itemPrice,
      this.invPrice});
  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      config.invCode: invCode,
      config.invDescrip: invDescrip,
      config.invQty: invQty,
      config.itemPrice: itemPrice,
      config.itemQty: itemQty,
      config.originalPrice: originalPrice,
      config.invDiscount: invDiscount,
      config.invPrice: invPrice
    };
    return map;
  }

  OrderDetail.fromMap(Map<String, dynamic> map) {
    invCode = map[config.invCode];
    invDescrip = map[config.invDescrip];
    invQty = map[config.invQty];
    itemPrice = map[config.itemPrice];
    itemQty = map[config.itemQty];
    originalPrice = map[config.originalPrice];
    invDiscount = map[config.invDiscount];
    invPrice = map[config.invPrice];
  }

  @override
  String toString() {
    return 'OrderDetail{invDescrip: $invDescrip, invQty: $invQty, invPrice: $invPrice}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetail &&
          runtimeType == other.runtimeType &&
          invCode == other.invCode &&
          invDescrip == other.invDescrip &&
          invQty == other.invQty &&
          invPrice == other.invPrice;

  @override
  int get hashCode =>
      invCode.hashCode ^
      invDescrip.hashCode ^
      invQty.hashCode ^
      invPrice.hashCode;
}

@JsonSerializable(explicitToJson: true)
class SalesOrder {
  String? custid;
  int? orderid;
  String? custName;
  String? remarks;
  String? orderdate;
  String? orderdocno;
  int? ordervalidity;
  String? latitude;
  String? longitude;
  List<OrderDetail>? orderDetails;

  SalesOrder(
      {this.custid,
      this.orderid,
      this.custName,
      this.remarks,
      this.orderdate,
      this.orderdocno,
      this.ordervalidity,
      this.orderDetails,
      this.latitude,
      this.longitude});
  factory SalesOrder.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderFromJson(json);
  Map<String, dynamic> toJson() => _$SalesOrderToJson(this);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      config.custid: custid,
      config.custname: custName,
      config.orderid: orderid,
      config.orderdocno: orderdocno,
      config.orderdate: orderdate,
      config.ordervalidity: ordervalidity,
      config.latitude: latitude,
      config.longitude: longitude
    };
    return map;
  }

  SalesOrder.fromMap(Map<String, dynamic> map) {
    custid = map[config.custid];
    custName = map[config.custname];
    orderid = map[config.orderid];
    orderdocno = map[config.orderdocno];
    orderdate = map[config.orderdate];
    ordervalidity = map[config.ordervalidity];
    latitude = map[config.latitude];
    longitude = map[config.longitude];
  }

  @override
  String toString() {
    return 'SalesOrder{custid: $custid, orderid: $orderid, orderdate: $orderdate, orderdocno: $orderdocno, ordervalidity: $ordervalidity, orderDetails: $orderDetails}';
  }
}

@JsonSerializable()
class InvoiceDetails {
  int? invid;
  String? itemDesc;
  String? remarks;
  double? vatRate;
  double? vat;
  double? itemQty;
  double? discount;
  double? qtysold;
  double? discAmt;
  double? originalPrice;
  double? total;
  double? rprice;

  InvoiceDetails(
      {this.invid,
      this.originalPrice,
      this.discount,
      this.vatRate,
      this.itemDesc,
      this.remarks,
      this.vat,
      this.itemQty,
      this.qtysold,
      this.discAmt,
      this.total,
      this.rprice});
  factory InvoiceDetails.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceDetailsToJson(this);

  @override
  String toString() {
    return 'InvoiceDetails{qtysold: $qtysold, total: $total, rprice: $rprice}';
  }
}

@JsonSerializable(explicitToJson: true)
class SalesInvoice {
  int? custid;
  int? salesrep;
  int? userid;
  int? deptid;
  int? costcenter;
  String? invdate;
  String? remarks;
  double? subtotal;
  double? granddiscount;
  double? vat;
  double? grandtotal;
  String? latitude;
  String? longitude;
  List<InvoiceDetails>? invDetails;

  SalesInvoice(
      {this.custid,
      this.granddiscount,
      this.salesrep,
      this.costcenter,
      this.invdate,
      this.subtotal,
      this.vat,
      this.remarks,
      this.grandtotal,
      this.invDetails,
      this.latitude,
      this.longitude,
      this.userid,
      this.deptid});
  factory SalesInvoice.fromJson(Map<String, dynamic> json) =>
      _$SalesInvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$SalesInvoiceToJson(this);

  @override
  String toString() {
    return 'SalesInvoice{custid: $custid, salesrep: $salesrep,id:$userid,deptid:$deptid, costcenter: $costcenter, invdate: $invdate, vat: $vat, grandtotal: $grandtotal, invDetails: $invDetails, remarks: $remarks}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesInvoice &&
          runtimeType == other.runtimeType &&
          custid == other.custid &&
          userid == other.userid &&
          deptid == other.deptid &&
          salesrep == other.salesrep &&
          costcenter == other.costcenter &&
          invdate == other.invdate &&
          subtotal == other.subtotal &&
          vat == other.vat &&
          grandtotal == other.grandtotal &&
          invDetails == other.invDetails;

  @override
  int get hashCode =>
      custid.hashCode ^
      userid.hashCode ^
      deptid.hashCode ^
      salesrep.hashCode ^
      costcenter.hashCode ^
      invdate.hashCode ^
      subtotal.hashCode ^
      vat.hashCode ^
      grandtotal.hashCode ^
      invDetails.hashCode;
}

@JsonSerializable()
class RecieptObj {
  int? custid;
  int? userid;
  int? deptid;
  int? salesrepid;
  int? costcenter;
  String? paymode;
  String? paydate;
  double? total;
  String? custcode;
  String? paybillno;

  RecieptObj(
      {this.custid,
      this.userid,
      this.deptid,
      this.salesrepid,
      this.costcenter,
      this.paymode,
      this.paydate,
      this.total,
      this.custcode,
      this.paybillno});
  factory RecieptObj.fromJson(Map<String, dynamic> json) =>
      _$RecieptObjFromJson(json);
  Map<String, dynamic> toJson() => _$RecieptObjToJson(this);
}

@JsonSerializable()
class InvoiceHistory {
  int? id;
  String? date;
  String? custname;
  String? remarks;
  double? amount;
  String? custcode;
  String? paybillno;

  InvoiceHistory(
      {this.id,
      this.date,
      this.custname,
      this.amount,
      this.remarks,
      this.custcode,
      this.paybillno});
  factory InvoiceHistory.fromJson(Map<String, dynamic> json) =>
      _$InvoiceHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceHistoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InvoiceHistoryObj {
  int? id;
  String? custcode;
  String? paybillno;
  double? totalAmount;
  String? invdate;
  String? remarks;
  String? custname;
  double? vatAmount;
  double? subtotalAmount;
  List<InvoiceHistoryDetail>? invoiceDetails;

  InvoiceHistoryObj(
      {this.id,
      this.custcode,
      this.paybillno,
      this.totalAmount,
      this.invdate,
      this.custname,
      this.remarks,
      this.vatAmount,
      this.subtotalAmount,
      this.invoiceDetails});
  factory InvoiceHistoryObj.fromJson(Map<String, dynamic> json) =>
      _$InvoiceHistoryObjFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceHistoryObjToJson(this);
}

@JsonSerializable()
class InvoiceHistoryDetail {
  String? itemname;
  double? totalprice;
  String? remarks;
  double? qty;
  double? discount;
  double? unitprice;
  String? custcode;
  String? paybillno;

  InvoiceHistoryDetail(
      {this.itemname,
      this.totalprice,
      this.qty,
      this.remarks,
      this.discount,
      this.unitprice,
      this.custcode,
      this.paybillno});
  factory InvoiceHistoryDetail.fromJson(Map<String, dynamic> json) =>
      _$InvoiceHistoryDetailFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceHistoryDetailToJson(this);
}

@JsonSerializable()
class OrderHistory {
  int? id;
  String? date;
  String? custname;
  double? amount;
  String? remarks;

  OrderHistory({this.id, this.date, this.custname, this.amount, this.remarks});
  factory OrderHistory.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$OrderHistoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ReqHistory {
  int? id;
  String? date;
  List<ReqDetHistory>? mrdetails;

  ReqHistory(this.id, this.date, this.mrdetails);
  factory ReqHistory.fromJson(Map<String, dynamic> json) =>
      _$ReqHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ReqHistoryToJson(this);
}

@JsonSerializable()
class ReqDetHistory {
  String? item;
  double? qty;

  ReqDetHistory(this.item, this.qty);
  factory ReqDetHistory.fromJson(Map<String, dynamic> json) =>
      _$ReqDetHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ReqDetHistoryToJson(this);
}
