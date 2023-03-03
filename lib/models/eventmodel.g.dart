// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as int?,
      description: json['description'] as String?,
      amount: json['amount'] as num?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
    };
