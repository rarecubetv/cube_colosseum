// Copyright (c) 2025 CubeCam
// Licensed under the MIT License

class Constants {
  static const String mainScreen = 'MainScreen';
  static const String streamerScreen = 'StreamerScreen';
  static const String viewerScreen = 'ViewerScreen';

  // Default Stream ID - should be unique for each stream
  static const String streamId = 'stream';

  // Server configuration - RARE□TV OvenMediaEngine
  static const String baseUrl = 'stream.rarecube.tv';
  static const int port = 3333;

  static String get remoteSocketUrl =>
      'wss://$baseUrl:$port/app/$streamId?direction=send';

  static String getStreamPath(String id) => 'wss://$baseUrl:$port/app/$id';

  // STUN servers for WebRTC
  static const List<Map<String, String>> iceServers = [
    {'url': 'stun:stun1.l.google.com:19302'},
    {'url': 'stun:178.33.166.29:3478'},
    {'url': 'stun:37.139.120.14:3478'},
    {'url': 'stun:194.149.74.157:3478'},
    {'url': 'stun:193.22.119.20:3478'},
    {'url': 'stun:stun.relay.metered.ca:80'},
  ];

  // WebRTC configuration
  static const Map<String, dynamic> mediaConstraints = {
    'audio': true,
    'video': {
      'mandatory': {
        'minWidth': '640',
        'minHeight': '480',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    }
  };

  static const Map<String, dynamic> offerSdpConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };
}
