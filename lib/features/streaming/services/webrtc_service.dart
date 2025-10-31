// Copyright (c) 2025 CubeCam
// Licensed under the MIT License

import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/message_model.dart';
import '../constants.dart';

abstract class WebRTCServiceListener {
  void onLocalStream(MediaStream stream);
  void onRemoteStream(MediaStream stream);
  void onIceCandidate(RTCIceCandidate candidate);
  void onConnectionStateChange(RTCPeerConnectionState state);
}

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  WebRTCServiceListener? _listener;
  final List<MyIceCandidate> _iceCandidates = [];

  List<MyIceCandidate> get iceCandidates => _iceCandidates;
  RTCPeerConnection? get peerConnection => _peerConnection;

  Future<void> initialize(WebRTCServiceListener listener) async {
    _listener = listener;
    await _createPeerConnection();
  }

  Future<void> _createPeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': Constants.iceServers,
      'sdpSemantics': 'unified-plan',
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _iceCandidates.add(MyIceCandidate.fromWebRTC(candidate));
      _listener?.onIceCandidate(candidate);
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        _listener?.onRemoteStream(event.streams[0]);
      }
    };

    _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      _listener?.onConnectionStateChange(state);
    };
  }

  Future<void> startLocalStream({bool isFrontCamera = true}) async {
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '720',
          'minHeight': '480',
          'minFrameRate': '10',
        },
        'facingMode': isFrontCamera ? 'user' : 'environment',
        'optional': [],
      }
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

      // Add local stream tracks to peer connection
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      _listener?.onLocalStream(_localStream!);
    } catch (e) {
      print('Error starting local stream: $e');
      rethrow;
    }
  }

  Future<RTCSessionDescription> createOffer() async {
    final constraints = Constants.offerSdpConstraints;
    final description = await _peerConnection!.createOffer(constraints);
    await _peerConnection!.setLocalDescription(description);
    return description;
  }

  Future<RTCSessionDescription> createAnswer() async {
    final constraints = Constants.offerSdpConstraints;
    final description = await _peerConnection!.createAnswer(constraints);
    await _peerConnection!.setLocalDescription(description);

    // Wait a bit for ICE gathering
    await Future.delayed(const Duration(seconds: 3));

    return description;
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await _peerConnection?.setRemoteDescription(description);
  }

  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    await _peerConnection?.addCandidate(candidate);
  }

  void clearIceCandidates() {
    _iceCandidates.clear();
  }

  Future<void> dispose() async {
    await _localStream?.dispose();
    await _peerConnection?.close();
    _localStream = null;
    _peerConnection = null;
    _listener = null;
    _iceCandidates.clear();
  }

  void switchCamera() {
    if (_localStream != null) {
      final videoTracks = _localStream!.getVideoTracks();
      if (videoTracks.isNotEmpty) {
        Helper.switchCamera(videoTracks.first);
      }
    }
  }

  void toggleMicrophone() {
    if (_localStream != null) {
      final audioTracks = _localStream!.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        audioTracks.first.enabled = !audioTracks.first.enabled;
      }
    }
  }

  void toggleCamera() {
    if (_localStream != null) {
      final videoTracks = _localStream!.getVideoTracks();
      if (videoTracks.isNotEmpty) {
        videoTracks.first.enabled = !videoTracks.first.enabled;
      }
    }
  }

  bool get isMicrophoneEnabled {
    if (_localStream == null) return false;
    final tracks = _localStream!.getAudioTracks();
    return tracks.isNotEmpty && tracks.first.enabled;
  }

  bool get isCameraEnabled {
    if (_localStream == null) return false;
    final tracks = _localStream!.getVideoTracks();
    return tracks.isNotEmpty && tracks.first.enabled;
  }
}
