// Copyright (c) 2025 CubeCam
// Licensed under the MIT License

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/message_model.dart';
import '../services/socket_client.dart';
import '../services/webrtc_service.dart';
import '../utils/constants.dart';

class ViewerProvider extends ChangeNotifier
    implements SocketClientListener, WebRTCServiceListener {
  final SocketClient _socketClient = SocketClient();
  final WebRTCService _webrtcService = WebRTCService();

  MediaStream? _remoteStream;
  RTCPeerConnectionState _connectionState = RTCPeerConnectionState.RTCPeerConnectionStateNew;
  bool _isConnected = false;
  String? _streamId;

  MediaStream? get remoteStream => _remoteStream;
  RTCPeerConnectionState get connectionState => _connectionState;
  bool get isConnected => _isConnected;
  String? get streamId => _streamId;

  Future<void> initialize(String streamId) async {
    _streamId = streamId;
    try {
      await _webrtcService.initialize(this);
      _socketClient.init(Constants.getStreamPath(streamId), this);
    } catch (e) {
      debugPrint('Error initializing viewer: $e');
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
    // Viewer doesn't need local stream
  }

  @override
  void onRemoteStream(MediaStream stream) {
    _remoteStream = stream;
    debugPrint('Remote stream received');
    notifyListeners();
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

  @override
  void dispose() {
    _socketClient.close();
    _webrtcService.dispose();
    super.dispose();
  }
}
