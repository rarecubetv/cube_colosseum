// Copyright (c) 2025 CubeCam
// Licensed under the MIT License

import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String? command;
  int? id;
  MySessionDescription? sdp;
  List<MyIceCandidate> candidates;

  MessageModel({
    this.command,
    this.id,
    this.sdp,
    List<MyIceCandidate>? candidates,
  }) : candidates = candidates ?? [];

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

@JsonSerializable()
class MySessionDescription {
  final String type;
  final String sdp;

  MySessionDescription({
    required this.type,
    required this.sdp,
  });

  factory MySessionDescription.fromJson(Map<String, dynamic> json) =>
      _$MySessionDescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$MySessionDescriptionToJson(this);

  RTCSessionDescription toWebRTCSessionDescription() {
    return RTCSessionDescription(
      sdp,
      type == 'offer' ? 'offer' : 'answer',
    );
  }
}

@JsonSerializable()
class MyIceCandidate {
  final String candidate;
  final int sdpMLineIndex;
  final String? sdpMid;

  MyIceCandidate({
    required this.candidate,
    required this.sdpMLineIndex,
    this.sdpMid,
  });

  factory MyIceCandidate.fromJson(Map<String, dynamic> json) =>
      _$MyIceCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$MyIceCandidateToJson(this);

  RTCIceCandidate toWebRTCIceCandidate() {
    return RTCIceCandidate(
      candidate,
      sdpMid ?? '',
      sdpMLineIndex,
    );
  }

  factory MyIceCandidate.fromWebRTC(RTCIceCandidate candidate) {
    return MyIceCandidate(
      candidate: candidate.candidate ?? '',
      sdpMLineIndex: candidate.sdpMLineIndex ?? 0,
      sdpMid: candidate.sdpMid,
    );
  }
}
