// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minstatementmodels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Minstatement _$MinstatementFromJson(Map<String, dynamic> json) => Minstatement(
      id: json['id'] as int?,
      type: json['type'] as String?,
      date: json['date'] as String?,
      cramt: json['cramt'] as num?,
      dramt: json['dramt'] as num?,
    );

Map<String, dynamic> _$MinstatementToJson(Minstatement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cramt': instance.cramt,
      'dramt': instance.dramt,
      'date': instance.date,
      'type': instance.type,
    };
