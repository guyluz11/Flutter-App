// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonoff_s20_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SonoffS20Dtos _$_$_SonoffS20DtosFromJson(Map<String, dynamic> json) {
  return _$_SonoffS20Dtos(
    deviceDtoClass: json['deviceDtoClass'] as String?,
    id: json['id'] as String?,
    defaultName: json['defaultName'] as String?,
    roomId: json['roomId'] as String?,
    roomName: json['roomName'] as String?,
    deviceStateGRPC: json['deviceStateGRPC'] as String?,
    stateMassage: json['stateMassage'] as String?,
    senderDeviceOs: json['senderDeviceOs'] as String?,
    senderDeviceModel: json['senderDeviceModel'] as String?,
    senderId: json['senderId'] as String?,
    deviceActions: json['deviceActions'] as String?,
    deviceTypes: json['deviceTypes'] as String?,
    compUuid: json['compUuid'] as String?,
    deviceSecondWiFi: json['deviceSecondWiFi'] as String?,
    deviceMdnsName: json['deviceMdnsName'] as String?,
    lastKnownIp: json['lastKnownIp'] as String?,
  );
}

Map<String, dynamic> _$_$_SonoffS20DtosToJson(_$_SonoffS20Dtos instance) =>
    <String, dynamic>{
      'deviceDtoClass': instance.deviceDtoClass,
      'id': instance.id,
      'defaultName': instance.defaultName,
      'roomId': instance.roomId,
      'roomName': instance.roomName,
      'deviceStateGRPC': instance.deviceStateGRPC,
      'stateMassage': instance.stateMassage,
      'senderDeviceOs': instance.senderDeviceOs,
      'senderDeviceModel': instance.senderDeviceModel,
      'senderId': instance.senderId,
      'deviceActions': instance.deviceActions,
      'deviceTypes': instance.deviceTypes,
      'compUuid': instance.compUuid,
      'deviceSecondWiFi': instance.deviceSecondWiFi,
      'deviceMdnsName': instance.deviceMdnsName,
      'lastKnownIp': instance.lastKnownIp,
    };