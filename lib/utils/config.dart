// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import '../database/sessionpreferences.dart';
import '../models/usermodels.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

final String localUrl = 'https://192.168.43.89:8181/AnchorERP/fused/api/';
final String qaUrl = 'https://erpqa.netrixbiz.com/AnchorERP/fused/api/';
final String jwinesUrl = 'https://erpqa.netrixbiz.com/AnchorERP/fused/api/';
final String shobolUrl = 'https://shobolerp.jwines.co.ke/AnchorERP/fused/api/';
final String expressoUrl =
    'https://expressoerp.jwines.co.ke/AnchorERP/fused/api/';
final String companySettings = 'COMPANY_SETTINGS';
final String domainUrl = '/AnchorERP/fused/api/';
final String erpUrl = 'https://';
final String get = 'GET';
final String post = 'POST';
final String put = 'PUT';
final String materialRequisition = 'materialRequisition';
final String salesOrder = 'salesOrder';
final String invoice = 'invoice';
final String changePass = 'changePass';
final String forgotPass = 'forgotPass';
final String tbSalesOrder = 'tbSalesOrder';
final String tbOrderDetail = 'tbOrderDetail';
final String tbInventoryDetail = 'tbInventoryDetail';
final String tbMaterialReqDetail = 'tbInventoryDetail';
final String invCode = 'invCode';
final String invDescrip = 'invDescrip';
final String invQty = 'invQty';
final String itemPrice = 'itemPrice';
final String itemQty = 'itemQty';
final String id = 'id';
final String originalPrice = 'originalPrice';
final String invDiscount = 'invDiscount';
final String invPrice = 'invPrice';
final String custid = 'custid';
final String custname = 'custname';
final String dbPath = 'jwines_db.db';
final String orderid = 'orderid';
final String orderdocno = 'orderdocno';
// final String remarks = 'remarks';
final String orderdate = 'orderdate';
final String ordervalidity = 'ordervalidity';
final String latitude = 'latitude';
final String longitude = 'longitude';
final String appVersion = 'appVersion';

Future<String> getBaseUrl() async {
  CompanySettings settings = await SessionPreferences().getCompanySettings();
  return settings.baseUrl!;
}

Future readResponse(HttpClientResponse response) {
  var completer = new Completer();
  var contents = new StringBuffer();
  response.transform(utf8.decoder).listen((data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}

Future<HttpClientResponse> getRequestObject(String url, String requestMethod,
    {String? body, ProgressDialog? dialog}) async {
  HttpClient httpClient = new HttpClient();
  httpClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  Uri uri = Uri.parse(url);
  print(uri);
  late HttpClientRequest request;
  late HttpClientResponse response;
  if (requestMethod == get) {
    request = await httpClient.getUrl(uri);
  } else if (requestMethod == post) {
    request = await httpClient.postUrl(uri);
    if (body != null) {
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(body));
      print(request);
    }
  } else if (requestMethod == put) {
    request = await httpClient.putUrl(uri);
    if (body != null) {
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(body));
    }
  }

  try {
    response = await request.close();
    if (dialog != null && dialog.isShowing()) {
      dialog.hide();
    }
  } catch (e) {
    if (dialog != null && dialog.isShowing()) {
      dialog.hide();
    }
    Fluttertoast.showToast(msg: 'Exception caught on mobile');
    print(e);
  }
  if (response != null) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return response;
    } else {
      if (dialog != null && dialog.isShowing()) {
        dialog.hide();
      }
      // Fluttertoast.showToast(msg: 'Error $statusCode occurred');
    }
  } else {
    if (dialog != null && dialog.isShowing()) {
      dialog.hide();
    }
    Fluttertoast.showToast(msg: 'There was no response from the server');
  }
  return response;
}
