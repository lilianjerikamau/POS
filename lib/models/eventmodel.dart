import 'package:json_annotation/json_annotation.dart';
part 'eventmodel.g.dart';

@JsonSerializable()
class Event {
  Event({this.id, this.description, this.amount});

  int? id;
  String? description;
  num? amount;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        description: json["description"],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "amount": amount,
      };
}
