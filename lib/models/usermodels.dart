import 'package:json_annotation/json_annotation.dart';

part 'usermodels.g.dart';

@JsonSerializable()
class User {
  User(
      {this.id,
      this.fullname,
      this.email,
      this.username,
      this.password,
      this.resetpassword,
      this.companyname,
      this.hrid,
      this.costcenter,
      this.custid,
      this.branchname,
      this.subscription,
      this.technician,
      this.mobileno,
      this.memberno,
      this.balance});

  int? id;
  String? fullname;
  String? mobileno;
  int? costcenter;
  String? memberno;
  String? email;
  String? username;
  String? password;
  bool? resetpassword;
  int? hrid;
  int? custid;
  num? balance;
  int? subscription;
  String? companyname;
  String? branchname;
  bool? technician;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      fullname: json["fullname"],
      memberno: json["memberno"],
      mobileno: json["mobileno"],
      resetpassword: json['resetpassword'],
      email: json["email"],
      username: json["username"],
      // subscription: json["subscription"],
      companyname: json['companyname'],
      costcenter: json["costcenter"],
      hrid: json["hrid"],
      branchname: json["branchname"],
      balance: json["balance"],
      technician: json["technician"],
      custid: json["custid"],
      password: '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobileno": mobileno,
        "fullname": fullname,
        "email": email,
        "memberno": memberno,
        "costcenter": costcenter,
        "username": username,
        'resetpassword': resetpassword,
        "companyname": companyname,
        "subscription": subscription,
        "balance": balance,
        "hrid": hrid,
        "custid": custid,
        "branchname": branchname,
        "technician": technician,
      };
}

@JsonSerializable()
class Customer {
  int? custid;
  String? company;
  num? balance;

  Customer({this.custid, this.company, this.balance});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  String toString() {
    return 'Customer{custid: $custid}';
  }
}

class CompanySettings {
  String? baseUrl;
  String? imageName;

  CompanySettings({this.baseUrl, this.imageName});
}
