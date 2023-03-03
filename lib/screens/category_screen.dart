import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:posapp/models/inventorymodels.dart';
import 'package:posapp/models/salesmodels.dart';
import 'package:posapp/screens/cart_screen.dart';
import 'package:posapp/screens/sidemenu/side_menu.dart';
import 'package:posapp/utils/config.dart' as Config;

class CategoryScreen extends StatefulWidget {
  int categoryId;
  String description;

  CategoryScreen(this.description, this.categoryId, {Key? key})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  InventoryItem? _selectedItem;
  var list;
  var categoryId;
  List<InventoryItem>? _inventoryItems;
  List<InvClass>? _invClasses;
  List newlist = [];
  List<String>? _invClassDescs = [];
  List<OrderDetail> _orderDetails = [];
  List<InvoiceDetails> _invDetails = [];
  InvClass? _invClass;
  late BuildContext _context;
  bool _searchmode = false;
  String? _searchString, _invClassDesc;
  @override
  void initState() {
    categoryId = widget.categoryId;
    _searchString = 'na';

    Future.delayed(Duration.zero, () {
      this._fetchInventoryItems();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(debtid: null,),
              ));
        },
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
              : Text(widget.description),
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
      body: _body(),
    );
  }

  _body() {
    if (_inventoryItems != null && _inventoryItems!.isNotEmpty) {
      _inventoryItems!.forEach((invitem) {
        String? description = invitem.description!;
      });

      return _listViewBuilder(_inventoryItems!);
    } else {
      return Center(
        child: Text(
          'No items in ${widget.description} category,Try Again!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }
  }

  _listViewBuilder(List<InventoryItem> data) {
    return ListView.builder(
        itemBuilder: (bc, i) {
          InventoryItem invitem = data.elementAt(i);
          String? description = invitem.description;
          num? price = invitem.rprice;

          return Card(
            margin: const EdgeInsets.all(10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.red, width: 0),
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),

              // padding: const EdgeInsets.all(10.0),
              child: Container(
                child: ListTile(
                  leading: const Icon(
                    Icons.menu_open,
                    color: Colors.red,
                  ),
                  title: Text(description!,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Divider(),
                      Text(
                        description != null
                            ? 'Item Name: $description'
                            : 'Item Name: Item Name',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Text(
                        price != null ? 'Price: $price' : 'Price: 0',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: data.length);
  }

  _fetchInventoryItems() async {
    String url = await Config.getBaseUrl();
    HttpClientResponse response = await Config.getRequestObject(
      url + 'inventory/list/?invclassid=$categoryId&invname=$_searchString',
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
}
