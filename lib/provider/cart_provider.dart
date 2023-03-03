import 'package:flutter/cupertino.dart';

import '../database/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';
class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 1;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;
  double _totalvat= 0.0;
  double get totalvat => _totalvat;
  double get totalPrice => _totalPrice;

  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    cart = await dbHelper.getCartList();
    print('cart items');
    print(cart);
    notifyListeners();
    return cart;
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setInt('item_quantity', _quantity);
    prefs.setDouble('total_price', _totalPrice);
    prefs.setDouble('vat', _totalvat);
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
    _totalvat = prefs.getDouble('vat')??0;
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefsItems();
    return _counter;
  }

  void addQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity!.value = cart[index].quantity!.value + 1;
    _setPrefsItems();
    notifyListeners();
  }

  void deleteQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);
    _setPrefsItems();
    notifyListeners();
  }

  int getQuantity(int quantity) {
    _getPrefsItems();
    return _quantity;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefsItems();
    notifyListeners();
  }
  // void addVAT(double vat) {
  //   _totalvat = _totalvat + vat;
  //   _setPrefsItems();
  //   notifyListeners();
  // }
  void removeTotalPrice(double productPrice ,double vat) {
    _totalPrice = _totalPrice - productPrice;
    _totalvat = _totalvat - vat;
    _setPrefsItems();
    notifyListeners();
  }
  // void removeTotalVat(double vat) {
  //   _totalvat = _totalvat - vat;
  //   _setPrefsItems();
  //   notifyListeners();
  // }
  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }
  // double getTotalVat() {
  //   _getPrefsItems();
  //   return _totalvat;
  // }
}