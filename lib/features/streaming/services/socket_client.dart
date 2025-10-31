// Copyright (c) 2025 CubeCam
// Licensed under the MIT License

import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/message_model.dart';

abstract class SocketClientListener {
  void onSocketOpened();
  void onSocketClosed();
  void onSocketError(dynamic error);
  void onSocketMessage(MessageModel message);
}

class SocketClient {
  WebSocketChannel? _channel;
  SocketClientListener? _listener;
  String? _currentUrl;

  bool get isConnected => _channel != null;

  void init(String socketUrl, SocketClientListener listener) {
    _listener = listener;
    _currentUrl = socketUrl;
    _connect();
  }

  void _connect() {
    if (_currentUrl == null) return;

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_currentUrl!));

      // Notify listener that socket is opened
      _listener?.onSocketOpened();

      // Listen to incoming messages
      _channel!.stream.listen(
        (message) {
          try {
            final Map<String, dynamic> json = jsonDecode(message as String);
            final messageModel = MessageModel.fromJson(json);
            _listener?.onSocketMessage(messageModel);
          } catch (e) {
            _listener?.onSocketError(e);
          }
        },
        onError: (error) {
          _listener?.onSocketError(error);
        },
        onDone: () {
          _listener?.onSocketClosed();
        },
        cancelOnError: false,
      );
    } catch (e) {
      _listener?.onSocketError(e);
    }
  }

  void sendMessage(dynamic data) {
    if (_channel == null) return;

    try {
      String jsonString;
      if (data is MessageModel) {
        jsonString = jsonEncode(data.toJson());
      } else if (data is Map) {
        jsonString = jsonEncode(data);
      } else {
        jsonString = data.toString();
      }
      _channel!.sink.add(jsonString);
    } catch (e) {
      _listener?.onSocketError(e);
    }
  }

  void close() {
    _channel?.sink.close();
    _channel = null;
    _listener = null;
  }
}
