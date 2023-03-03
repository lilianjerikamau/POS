import 'package:json_annotation/json_annotation.dart';
part 'bookmodel.g.dart';

@JsonSerializable()
class Book {
  Book({this.id, this.timeslot, this.qty});

  int? id;
  String? timeslot;
  num? qty;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        timeslot: json["timeslot"],
        qty: json['qty'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "timeslot": timeslot,
        "qty": qty,
      };
}
