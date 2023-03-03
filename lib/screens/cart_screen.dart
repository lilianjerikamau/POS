import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posapp/screens/bluetooth_screen.dart';
import 'package:provider/provider.dart';
import 'package:posapp/database/db_helper.dart';
import 'package:posapp/models/cart_model.dart';
import 'package:posapp/provider/cart_provider.dart';
import 'package:posapp/utils/config.dart' as Config;
import 'dart:convert';
import 'package:posapp/models/usermodels.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/sessionpreferences.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'home.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class CartScreen extends StatefulWidget {
  final debtid;
  final tillmanid;
  final invDetails;
  const CartScreen({
    Key? key,
    required this.debtid,
    this.tillmanid,
    this.invDetails,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];
  late ValueNotifier<int?> totalPrice;
  late ValueNotifier<int?> totalVat;
  late ValueNotifier<int?> grandTotal;
  late double totalprice;
  num totalvat = 0;
  double grandtotal = 0;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _pressed = false;
  List<Cart> _invDetails = [];
  int? invid;
  double? sellingPrice;
  double? qty;
  User? _loggedInUser;
  List<Map<String, dynamic>>? postdetailsliat;
  @override
  void initState() {
    initPlatformState();
    SessionPreferences().getLoggedInUser().then((user) {
      setState(() {
        print('Logged innnnn');
        _loggedInUser = user;
        print(_loggedInUser?.hrid);
      });
    });

    super.initState();
    context.read<CartProvider>().getData();
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Cart'),
        actions: [
          Badge(
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
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  BluetoothScreen()));
          }, icon: Icon(Icons.bluetooth))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.cart.isEmpty) {
                  return const Center(
                      child: Text(
                    'Your Cart is Empty',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.cart.length,
                      itemBuilder: (context, index) {
// setState(() {
//   sellingPrice = provider.cart[index].productPrice!.toDouble();
//   invid = provider.cart[index].productPrice!;
//   qty = double.parse(provider.cart[index].qty.toString()) ;
//   grandtotal =grandtotal;
//   print('sellingPrice');
//   print(sellingPrice);
// });
                        // String formattedPrice =
                        // NumberFormat.currency(symbol: '')
                        //     .format(sellingPrice);
                        // String formattedTotal =
                        // NumberFormat.currency(symbol: '').format(total);
                        // grandTotal += total;
                        // message +=
                        // "$desc\nQuantity : $qty\nSelling price : $formattedPrice Kshs\nTotal price : $formattedTotal Kshs\n\n";

                        return Card(
                          color: Colors.blueGrey.shade200,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Image(
                                //   height: 80,
                                //   width: 80,
                                //   image:
                                //   AssetImage(provider.cart[index].remarks!),
                                // ),
                                SizedBox(
                                  width: 130,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Name: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${provider.cart[index].productName!}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Code: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${provider.cart[index].invCode!}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'VAT: ' r"KSH",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${provider.cart[index].vat!}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Price: ' r"KSH",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${provider.cart[index].productPrice!}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder<int>(
                                    valueListenable:
                                        provider.cart[index].quantity!,
                                    builder: (context, val, child) {
                                      return PlusMinusButtons(
                                        addQuantity: () {
                                          cart.addQuantity(
                                              provider.cart[index].id!);
                                          dbHelper!
                                              .updateQuantity(Cart(
                                                  id: index,
                                                  productId: index.toString(),
                                                  productName: provider
                                                      .cart[index].productName,
                                                  vat: provider.cart[index].vat,
                                                  productPrice: provider
                                                      .cart[index].productPrice,
                                                  quantity: ValueNotifier(
                                                      provider.cart[index]
                                                          .quantity!.value),
                                                  invCode: provider
                                                      .cart[index].invCode,
                                                  remarks: provider
                                                      .cart[index].remarks))
                                              .then((value) {
                                            setState(() {
                                              cart.addTotalPrice(double.parse(
                                                  provider
                                                      .cart[index].productPrice
                                                      .toString()));
                                              // cart.addVAT(double.parse(provider
                                              //     .cart[index].vat
                                              //     .toString()));
                                            });
                                          });
                                        },
                                        deleteQuantity: () {
                                          cart.deleteQuantity(
                                              provider.cart[index].id!);

                                          cart.removeTotalPrice(
                                              double.parse(provider
                                                  .cart[index].productPrice
                                                  .toString()),
                                              double.parse(provider
                                                  .cart[index].vat
                                                  .toString()));
                                          // cart.removeTotalVat(double.parse(
                                          //     provider.cart[index].vat
                                          //         .toString()));
                                        },
                                        text: val.toString(),
                                      );
                                    }),
                                IconButton(
                                    onPressed: () {
                                      dbHelper!.deleteCartItem(
                                          provider.cart[index].id!);
                                      provider
                                          .removeItem(provider.cart[index].id!);
                                      provider.removeCounter();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade800,
                                    )),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Consumer<CartProvider>(
            builder: (BuildContext context, value, Widget? child) {
              totalPrice = ValueNotifier(null);
              totalVat = ValueNotifier(null);
              grandTotal = ValueNotifier(null);
              for (var element in value.cart) {
                totalPrice.value =
                    (element.productPrice!.toInt() * element.quantity!.value) +
                        (totalPrice.value ?? 0);
              }
              for (var element in value.cart) {
                totalVat.value =
                    (element.vat!.toInt() * element.quantity!.value) +
                        (totalVat.value ?? 0);
              }
              if (totalVat.value != null && totalPrice.value != null) {
                grandTotal.value =
                    (totalVat.value!.toInt() + totalPrice.value!.toInt());
                grandtotal = double.parse(
                    (totalVat.value!.toInt() + totalPrice.value!.toInt())
                        .toString());
              }
              return Column(
                children: [
                  ValueListenableBuilder<int?>(
                      valueListenable: totalVat,
                      builder: (context, val, child) {
                        return ReusableWidget(
                            title: 'VAT-Total',
                            value: r'KSH' + (val?.toStringAsFixed(2) ?? '0'));
                      }),
                  ValueListenableBuilder<int?>(
                      valueListenable: totalPrice,
                      builder: (context, val, child) {
                        return ReusableWidget(
                            title: 'Sub-Total',
                            value: r'KSH' + (val?.toStringAsFixed(2) ?? '0'));
                      }),
                  ValueListenableBuilder<int?>(
                      valueListenable: grandTotal,
                      builder: (context, val, child) {
                        return ReusableWidget(
                            title: 'Grand-Total',
                            value: r'KSH' + (val?.toStringAsFixed(2) ?? '0'));
                      }),
                ],
              );
            },
          )
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          _getDeviceItems();
          _submit();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Payment Successful'),
          //     duration: Duration(seconds: 2),
          //   ),
          // );
        },
        child: Container(
          color: Colors.yellow.shade600,
          alignment: Alignment.center,
          height: 50.0,
          child: const Text(
            'Proceed to Pay',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

  }
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name!),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
      String message, {
        Duration duration: const Duration(seconds: 3),
      }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
  Future uploadposdatails() async {
    for (int i = 0; i < _invDetails.length; i++) {
      print(_invDetails[i].qty);
      postdetailsliat = _invDetails.map((e) {
        return {
          "invid": e.productId,
          "rprice": e.productPrice,
          "qtysold": e.qty,
          "total": grandtotal
        };
      }).toList();
    }
    // _submit();
  }

  _getPosDetails() {
    var cart = context.read<CartProvider>().cart;
    if (cart.isNotEmpty) {
      setState(() {
        cart.sort((a, b) =>
            a.invCode!.toLowerCase().compareTo(b.invCode!.toLowerCase()));
        _invDetails = cart;
        if (_invDetails != null && _invDetails.isNotEmpty) {
          _invDetails.forEach((invdetail) {
            setState(() {
              uploadposdatails();
              // invid = int.parse(invdetail.productId!);
              // qty = double.parse(invdetail.qty.toString());
              // sellingPrice = double.parse(invdetail.productPrice.toString());
              // totalprice =
              //     grandtotal += double.parse(invdetail.productPrice.toString());
            });
          });
        }
        // setState(() {
        //   _invDetails.add(widget.invDetails);
        // });
      });
    }
  }

  _submit() async {
    _getPosDetails();
    print(widget.invDetails);
    showDialog(
        context: this.context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Pay'),
            content: Text('Are you sure you want to submit Payment?'),
            actions: <Widget>[
              MaterialButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  }),
              MaterialButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    ProgressDialog dial = new ProgressDialog(context,
                        type: ProgressDialogType.Normal);
                    dial.style(
                      message: 'Submiting payment',
                    );
                    dial.show();
                    String demoUrl = await Config.getBaseUrl();
                    Uri url = Uri.parse(demoUrl + 'salesinvoice/posbill/');
                    print(url);
                    final response = await http.post(url,
                        headers: <String, String>{
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode(<String, dynamic>{
                          "userid": _loggedInUser!.id,
                          "custid": _loggedInUser!.hrid,
                          "deptid": widget.debtid,
                          "grandtotal": grandtotal,
                          "vattotal": double.parse(totalVat.value.toString()),
                          "posDetails": postdetailsliat,
                          "subtotal": double.parse(totalPrice.value.toString()),
                          "tillid": widget.tillmanid,
                          "remarks": "remarks"
                        }));
                    print(jsonEncode(<String, dynamic>{
                      "userid": _loggedInUser!.id,
                      "custid": _loggedInUser!.hrid,
                      "deptid": widget.debtid,
                      "grandtotal": grandtotal,
                      "vattotal": double.parse(totalVat.value.toString()),
                      "posDetails": postdetailsliat,
                      "subtotal": double.parse(totalPrice.value.toString()),
                      "tillid": widget.tillmanid,
                      "remarks": "remarks"
                    }));

                    if (response != null) {
                      dial.hide();
                      int statusCode = response.statusCode;
                      if (statusCode == 200) {
                        return _showDialog(this.context);
                      } else {
                        dial.hide();
                        print(
                            "Submit Status code::" + response.body.toString());
                        showAlertDialog(this.context, response.body);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'There was no response from the server');
                    }
                  },
                  child: Text('Yes'))
            ],
          );
        });
  }

  void _showDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home(0, "", 0)));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Success!",
        style: TextStyle(color: Colors.green),
      ),
      content: Text("Successful!"),
      actions: [
        okButton,
      ],
    );
    //   context: context,
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return CupertinoAlertDialog(
            title: Text('Error'),
            content: Text('$message'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home(0, "", 0)),
                    );
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
      required this.addQuantity,
      required this.deleteQuantity,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(text),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
