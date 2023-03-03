import 'package:flutter/cupertino.dart';

class Cart {
  late final int? id;
  final String? productId;
  final String? productName;
  final int? vat;
  final int? productPrice;
  final ValueNotifier<int>? quantity;
  final int? qty;
  final String? invCode;
  final String? remarks;

  Cart({required this.id,
    required this.productId,
    required this.productName,
    required this.vat,
    this.qty,
    required this.productPrice,
    required this.quantity,
    required this.invCode,
    required this.remarks});

  Cart.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        productId = data['productId'],
        productName = data['productName'],
  qty= data['quantity'],
        vat = data['vat'],
        productPrice = data['productPrice'],
        quantity = ValueNotifier(data['quantity']),
        invCode = data['invCode'],
        remarks = data['remarks'];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'vat': vat,
      'productPrice': productPrice,
      'quantity': quantity?.value,
      'invCode': invCode,
      'remarks': remarks,
    };
  }
  Map<String, dynamic> quantityMap() {
    return {
      'productId': productId,
      'quantity': quantity!.value,
    };
  }
}