import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:ruiru_app/screens/category_meals_screen.dart';
import 'dart:math' as math;

import 'package:posapp/screens/category_screen.dart';
import 'package:posapp/screens/home.dart';

class CategoryItem extends StatefulWidget {
  final int id;
  final String description;

  CategoryItem(this.id, this.description);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  int index = 0;
  late String description;
  late int categoryId;
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


    setState(() => index = random.nextInt(5));
    super.initState();
  }

  void selectCategory(BuildContext context) {

    description = widget.description;
    categoryId = widget.id;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(categoryId, description,0),
        ));
  }

  @override
  double sizeBool = 20;
  Widget build(BuildContext context) {
    return SafeArea(
      child: InkWell(

        onHover: ((isHovering) {
          if (isHovering) {
            setState(() {
              sizeBool = isHovering ? 50 : 20;
            });
          }
        }),
        onTap: () {
          selectCategory(context);
          print(widget.description);
        },
        splashColor: colors[index],
        borderRadius: BorderRadius.circular(20),
        child: Container(
          // padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.description,
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
                color: colors[index],
                size: 20,
              ),
            ],
          ),
          decoration: BoxDecoration(
              // border: Border.all(color: colors[index]),
              gradient: LinearGradient(colors: [
                Colors.grey.withOpacity(0.4),
                Colors.grey.withOpacity(0.4)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
