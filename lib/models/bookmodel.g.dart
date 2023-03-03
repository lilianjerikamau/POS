// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      id: json['id'] as int?,
      timeslot: json['timeslot'] as String?,
      qty: json['qty'] as num?,
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'timeslot': instance.timeslot,
      'qty': instance.qty,
    };
