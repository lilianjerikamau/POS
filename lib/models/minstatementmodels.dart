import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'minstatementmodels.g.dart';

@JsonSerializable()
class Minstatement {
  Minstatement({this.id, this.type, this.date, this.cramt, this.dramt});

  int? id;
  num? cramt;
  num? dramt;
  String? date;
  String? type;

  factory Minstatement.fromJson(Map<String, dynamic> json) => Minstatement(
      id: json["id"],
      cramt: json["cramt"],
      dramt: json["dramt"],
      date: json["date"],
      type: json["type"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "cramt": cramt, "dramt": dramt, "date": date, "type": type};
}
