// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  command: json['command'] as String?,
  id: (json['id'] as num?)?.toInt(),
  sdp: json['sdp'] == null
      ? null
      : MySessionDescription.fromJson(json['sdp'] as Map<String, dynamic>),
  candidates: (json['candidates'] as List<dynamic>?)
      ?.map((e) => MyIceCandidate.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'command': instance.command,
      'id': instance.id,
      'sdp': instance.sdp,
      'candidates': instance.candidates,
    };

MySessionDescription _$MySessionDescriptionFromJson(
  Map<String, dynamic> json,
) => MySessionDescription(
  type: json['type'] as String,
  sdp: json['sdp'] as String,
);

Map<String, dynamic> _$MySessionDescriptionToJson(
  MySessionDescription instance,
) => <String, dynamic>{'type': instance.type, 'sdp': instance.sdp};

MyIceCandidate _$MyIceCandidateFromJson(Map<String, dynamic> json) =>
    MyIceCandidate(
      candidate: json['candidate'] as String,
      sdpMLineIndex: (json['sdpMLineIndex'] as num).toInt(),
      sdpMid: json['sdpMid'] as String?,
    );

Map<String, dynamic> _$MyIceCandidateToJson(MyIceCandidate instance) =>
    <String, dynamic>{
      'candidate': instance.candidate,
      'sdpMLineIndex': instance.sdpMLineIndex,
      'sdpMid': instance.sdpMid,
    };
