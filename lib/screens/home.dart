import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posapp/models/inventorymodels.dart';
import 'package:posapp/models/salesmodels.dart';

import 'package:posapp/screens/login_screen.dart';
import 'package:posapp/screens/sidemenu/side_menu.dart';
import 'package:posapp/utils/config.dart' as Config;
import 'package:posapp/widgets/category_item.dart';
import 'package:provider/provider.dart';
import '../database/db_helper.dart';
import '../database/sessionpreferences.dart';
import '../models/cart_model.dart';
import '../models/usermodels.dart';
import '../provider/cart_provider.dart';
import 'cart_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart';

class Home extends StatefulWidget {
  int id;
  final String description;
  int deptid;

  Home(this.id, this.description, this.deptid);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 0;
  late int colorindex = 0;
  late User _loggedInUser;
  var userid = null;
  var tillmanid = null;
  var deptid = null;
  InventoryItem? _selectedItem;
  var list;
  var prod_id = null;
  var prod_desc = null;
  var vat = null;
  var prod_price = null;
  var qty = null;
  var inv_code = null;
  List<InventoryItem>? _inventoryItems;
  List<InvClass>? _invClasses;
  List newlist = [];
  List newlist2 = [];
  List<String>? _invClassDescs = [];
  List<OrderDetail> _orderDetails = [];
  List _invDetails=[];
  InvClass? _invClass;
  bool isCategorySelected = false;
  late BuildContext _context;
  bool _searchmode = false;
  String? _searchString, _invClassDesc;

  TextEditingController priceController = TextEditingController();
  List colors = [
    Colors.red,
    Colors.purple,
    Colors.yellow,
    Colors.blue,
    Colors.green
  ];
  Random random = new Random();
  @override
  void initState() {
    SessionPreferences().getLoggedInStatus().then((loggedIn) {
      if (loggedIn == null || loggedIn == false) {
        setState(() {
          Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => LoginPage(),
              ));

          print("logged in is null");
        });
      } else {
        setState(() {});
        if (loggedIn) {
          SessionPreferences().getLoggedInUser().then((user) {
            setState(() {
              print('Logged innnnn');
              _loggedInUser = user;
              userid = _loggedInUser.id;
              deptid = widget.deptid;
              _fetchPOSTill();
            });
          });
        }
      }
    });
    setState(() => colorindex = random.nextInt(5));

    _fetchInvClasses();
    _fetchInventoryItems();
    _searchString = 'na';
    super.initState();
  }
  void _addCartItem(Cart cart) {
    setState(() {
      _invDetails.add(cart);
    });
  }
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    void saveData(int index) {
      dbHelper
          .insert(
        Cart(
            id: index,
            productId: prod_id.toString(),
            productName: prod_desc,
            vat: vat,
            productPrice: prod_price.toInt(),
            quantity: ValueNotifier(int.parse(priceController.text)),
            invCode: inv_code,
            remarks: "remarks"),
      )
          .then((value) {
        _addCartItem(value);
        cart.addTotalPrice(prod_price.toDouble());
        cart.addCounter();
        print('Product Added to cart');
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

    return Scaffold(
      floatingActionButton: Badge(
        badgeContent: Consumer<CartProvider>(
          builder: (context, value, child) {
            return Text(
              value.getCounter().toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            );
          },
        ),
        position: const BadgePosition(start: 30, bottom: 30),
        child: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  CartScreen(debtid: widget.deptid,tillmanid:tillmanid,invDetails:_invDetails,)));
            // invid:prod_id,rprice:prod_price,qtysold:int.parse(priceController.text
          },
          icon: const Icon(Icons.shopping_cart),
        ),
      ),
      drawer: GestureDetector(child: SideMenu()),
      appBar: AppBar(
          title: _searchmode
              ? TextFormField(
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Search item description',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _fetchInventoryItems();
                      if (_searchString == null) {
                        _searchString = 'na';
                      } else {
                        _searchString = value;
                      }
                    });
                  })
              : const Text('Menu Items'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  _fetchInventoryItems();
                  setState(() {
                    _searchString == null ? _searchString = 'na' : 'na';
                    _searchmode = true;
                  });
                })
          ]),
      body: _searchmode != true
          ? SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(25),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            childAspectRatio: 1 / 1,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15),
                    children: newlist
                        .map((catData) =>
                            CategoryItem(catData.id, catData.description))
                        .toList(),
                  ),
                ),
                widget.id != 0
                    ? Text(
                        widget.description,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    : Text(
                        'All Items',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                _inventoryItems != null
                    ? Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: GridView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(25),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 100,
                                  childAspectRatio: 1 / 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          children: _inventoryItems!.map((items) {
                            //user itemslist.map to loop over the list
                            return InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Enter Amount"),
                                    content: TextFormField(
                                      controller: priceController,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          child: const Text("Cancel"),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          print("index is");
                                          print(items.id);
                                          setState(() {
                                            prod_id = items.id;
                                            prod_desc = items.description;
                                            vat = items.vat;
                                            prod_price = items.rprice;
                                            qty = double.parse(priceController.text);
                                            inv_code = items.invCode;
                                            counter = random.nextInt(1000000);
                                            saveData(counter);

                                            print(_invDetails);
                                          });

                                          print(counter);
                                          Navigator.of(ctx).pop();
                                          Fluttertoast.showToast(
                                              msg: 'Item Added To Cart!',
                                              textColor: Colors.blue);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          child: const Text("Add to cart"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              splashColor: colors[colorindex],
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                // padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        items.description!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Icon(
                                      Icons.menu_open,
                                      color: colors[colorindex],
                                      size: 20,
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    // border: Border.all(color: colors[index]),
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.withOpacity(0.4),
                                          Colors.grey.withOpacity(0.4)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            );
                          }).toList(), //don't forget to to add .toList() at last of map,
                        ),
                      )
                    : Container()
              ]),
            )
          : _body(),
    );
  }

  _fetchInventoryItems() async {
    String url = await Config.getBaseUrl();
    HttpClientResponse response = await Config.getRequestObject(
      url + 'inventory/list/?invclassid=${widget.id}&invname=na',
      Config.get,
    );
    if (response != null) {
      response.transform(utf8.decoder).listen((data) async {
        print(data);
        var jsonResponse = json.decode(data);
        var list = jsonResponse as List;
        print(list);
        List<InventoryItem> items = list.map<InventoryItem>((json) {
          return InventoryItem.fromJson(json);
        }).toList();
        setState(() {
          _inventoryItems = items;
        });
      });
    }
  }

  _fetchInvClasses() async {
    String url = await Config.getBaseUrl();
    HttpClientResponse response =
        await Config.getRequestObject(url + 'inventory/invclass/', Config.get);
    if (response != null) {
      response.transform(utf8.decoder).listen((data) async {
        var jsonResponse = json.decode(data);
        list = jsonResponse as List;
        print(list);
        List<InvClass> response = list.map<InvClass>((json) {
          return InvClass.fromJson(json);
        }).toList();
        setState(() {
          newlist = response;
        });
        print(newlist);

        response.forEach((invc) {
          _invClassDescs!.add(invc.description!);
        });
        setState(() {
          _invClasses = response;
        });
      });
    }
  }

  _fetchPOSTill() async {
    String url = await Config.getBaseUrl();
    HttpClientResponse response = await Config.getRequestObject(
        url + 'mobileuser/postillmanagement/$userid?deptid=$deptid',
        Config.get);
    if (response != null) {
      response.transform(utf8.decoder).listen((data) async {
        var jsonResponse = json.decode(data);
        // list = jsonResponse as List;
        print('Json response is');
        print(jsonResponse);
        setState(() {
          tillmanid = jsonResponse[0]['id'];
          print(tillmanid);
          // tillmanid =int.parse(jsonResponsestring);
          _fetchPendingBill();
        });
        // List<InvClass> response = list.map<InvClass>((json) {
        //   return InvClass.fromJson(json);
        // }).toList();
        // setState(() {
        //   newlist = response;
        // });
        // print(newlist);
        //
        // response.forEach((invc) {
        //   _invClassDescs!.add(invc.description!);
        // });
        // setState(() {
        //   _invClasses = response;
        // });
      });
    }
  }

  _fetchPendingBill() async {
    String url = await Config.getBaseUrl();
    HttpClientResponse response = await Config.getRequestObject(
        url + 'salesinvoice/pendingbill/$userid?tillmanid=$tillmanid',
        Config.get);
    if (response != null) {
      response.transform(utf8.decoder).listen((data) async {
        var jsonResponse = json.decode(data);
        // list = jsonResponse as List;
        print('Json response is');
        print(jsonResponse);
        // List<InvClass> response = list.map<InvClass>((json) {
        //   return InvClass.fromJson(json);
        // }).toList();
        // setState(() {
        //   newlist = response;
        // });
        // print(newlist);
        //
        // response.forEach((invc) {
        //   _invClassDescs!.add(invc.description!);
        // });
        // setState(() {
        //   _invClasses = response;
        // });
      });
    }
  }

  _body() {
    if (_inventoryItems != null && _inventoryItems!.isNotEmpty) {
      _inventoryItems!.forEach((invitem) {
        String? description = invitem.description!;
      });

      return _listViewBuilder(_inventoryItems!);
    }
    return const Center(
      child: Text('Item not found,Try again'),
    );
  }

  _listViewBuilder(List<InventoryItem> data) {
    return ListView.builder(
        itemBuilder: (bc, i) {
          InventoryItem invitem = data.elementAt(i);
          String? description = invitem.description;
          num? price = invitem.rprice;

          return InkWell(
              onTap: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //       builder: (ctx) => NewForgotPassword()),
                // );
              },
              child: Text(description!));
        },
        itemCount: data.length);
  }
}
