// Copyright (c) 2025 CubeCam
// Licensed under the MIT License

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/message_model.dart';
import '../services/socket_client.dart';
import '../services/webrtc_service.dart';
import '../constants.dart';

class StreamerProvider extends ChangeNotifier
    implements SocketClientListener, WebRTCServiceListener {
  final SocketClient _socketClient = SocketClient();
  final WebRTCService _webrtcService = WebRTCService();

  MediaStream? _localStream;
  RTCPeerConnectionState _connectionState = RTCPeerConnectionState.RTCPeerConnectionStateNew;
  bool _isConnected = false;

  MediaStream? get localStream => _localStream;
  RTCPeerConnectionState get connectionState => _connectionState;
  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    try {
      await _webrtcService.initialize(this);
      await _webrtcService.startLocalStream(isFrontCamera: false);
      _socketClient.init(Constants.remoteSocketUrl, this);
    } catch (e) {
      debugPrint('Error initializing streamer: $e');
    }
  }

  // SocketClientListener implementation
  @override
  void onSocketOpened() {
    debugPrint('Socket opened');
    _isConnected = true;
    _socketClient.sendMessage(MessageModel(command: 'request_offer'));
    notifyListeners();
  }

  @override
  void onSocketClosed() {
    debugPrint('Socket closed');
    _isConnected = false;
    notifyListeners();
  }

  @override
  void onSocketError(dynamic error) {
    debugPrint('Socket error: $error');
  }

  @override
  void onSocketMessage(MessageModel message) async {
    debugPrint('Received message: ${message.command}');

    if (message.command == 'offer') {
      try {
        // Set remote description
        if (message.sdp != null) {
          await _webrtcService.setRemoteDescription(
            message.sdp!.toWebRTCSessionDescription(),
          );
        }

        // Add ice candidates
        for (final ice in message.candidates) {
          await _webrtcService.addIceCandidate(ice.toWebRTCIceCandidate());
        }

        // Create answer
        _webrtcService.clearIceCandidates();
        final answer = await _webrtcService.createAnswer();

        // Send answer back
        final response = MessageModel(
          command: 'answer',
          id: message.id,
          sdp: MySessionDescription(
            type: 'answer',
            sdp: answer.sdp ?? '',
          ),
          candidates: _webrtcService.iceCandidates,
        );

        _socketClient.sendMessage(response);
      } catch (e) {
        debugPrint('Error handling offer: $e');
      }
    }
  }

  // WebRTCServiceListener implementation
  @override
  void onLocalStream(MediaStream stream) {
    _localStream = stream;
    notifyListeners();
  }

  @override
  void onRemoteStream(MediaStream stream) {
    // Streamer doesn't need remote stream
  }

  @override
  void onIceCandidate(RTCIceCandidate candidate) {
    debugPrint('ICE candidate generated');
  }

  @override
  void onConnectionStateChange(RTCPeerConnectionState state) {
    _connectionState = state;
    debugPrint('Connection state: $state');
    notifyListeners();
  }

  void switchCamera() {
    _webrtcService.switchCamera();
  }

  void toggleMicrophone() {
    _webrtcService.toggleMicrophone();
    notifyListeners();
  }

  void toggleCamera() {
    _webrtcService.toggleCamera();
    notifyListeners();
  }

  bool get isMicrophoneEnabled => _webrtcService.isMicrophoneEnabled;
  bool get isCameraEnabled => _webrtcService.isCameraEnabled;

  @override
  void dispose() {
    _socketClient.close();
    _webrtcService.dispose();
    super.dispose();
  }
}
