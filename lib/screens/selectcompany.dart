import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posapp/database/sessionpreferences.dart';
import 'package:posapp/models/usermodels.dart';
import 'package:posapp/screens/login_screen.dart';
import 'package:posapp/utils/config.dart';

// ignore: must_be_immutable
class ChooseCompany extends StatefulWidget {
  void Function(String) companySelected;
  ChooseCompany(this.companySelected);

  @override
  _ChooseCompanyState createState() => _ChooseCompanyState();
}

class _ChooseCompanyState extends State<ChooseCompany> {
  final _companysettingurl = new TextEditingController();
  final _companyUrlKey = GlobalKey<FormState>();
  late String? _imgFromSettings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _companyUrlKey,
      appBar: AppBar(title: Text('Configure you current Company')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _companysettingurl,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Enter Company URL';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    labelText: 'Enter Company URL'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_companysettingurl.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please enter company url....",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.redAccent[900],
                      textColor: Colors.white,
                      fontSize: 16.0);
                  'Enter Company URL';
                } else {
                  SessionPreferences()
                      .setCompanySettings(CompanySettings(
                          baseUrl: erpUrl + _companysettingurl.text + domainUrl,
                          imageName: 'logo.png'))
                      .then((value) {
                    widget.companySelected('logo.png');
                  });
                  _loadImageFromSettings();
                  Fluttertoast.showToast(
                      msg: "Company setting updated successfully....",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.amberAccent);
                  Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => LoginPage(),
                      ));
                }
              },
              child: Text('Update Company'),
            ),

            // Card(
            //   elevation: 20,
            //   child: ListTile(
            //     onTap: (){
            //       String imgName = 'logo.png';
            //       SessionPreferences().setCompanySettings(CompanySettings(
            //           baseUrl: jwinesUrl,
            //           imageName: imgName
            //       )).then((value){
            //         widget.companySelected(imgName);
            //       });
            //     },leading: Image(image: AssetImage('images/logo.png')),
            //     title: Text('NGARA WINES'),
            //   ),
            // )
//            Padding(
//              padding: const EdgeInsets.symmetric(vertical: 10),
//              child: Card(
//                elevation: 20,
//                child: ListTile(
//                  onTap: (){
//                    String imgName = 'shoboh.jpg';
//                    SessionPreferences().setCompanySettings(CompanySettings(
//                        baseUrl: shobolUrl,
//                        imageName: imgName
//                    )).then((value){
//                      widget.companySelected(imgName);
//                    });
//                  },leading: Image(image: AssetImage('images/shoboh.jpg')),
//                  title: Text('Shoboh'),
//                ),
//              ),
//            ),
//            Card(
//              elevation: 20,
//              child: ListTile(
//                onTap: (){
//                  String imgName = 'expresso.jpg';
//                  SessionPreferences().setCompanySettings(CompanySettings(
//                      baseUrl: expressoUrl,
//                      imageName: imgName
//                  )).then((value){
//                    widget.companySelected(imgName);
//                  });
//                },
//                leading: Image(image: AssetImage('images/expresso.jpg')),
//                title: Text('Expresso'),
//              ),
//            )
          ],
        ),
      ),
    );
  }

  void _loadImageFromSettings() async {
    CompanySettings settings = await SessionPreferences().getCompanySettings();
    setState(() {
      _imgFromSettings = settings.imageName;
    });
  }
}
