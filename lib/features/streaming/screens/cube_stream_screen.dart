import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart' as provider_pkg;
import '../../../core/theme/app_colors.dart';
import '../providers/streamer_provider.dart';

/// CubeStream screen for live streaming to RARE□TV
/// Integrated with OvenMediaEngine at stream.rarecube.tv
class CubeStreamScreen extends StatefulWidget {
  const CubeStreamScreen({super.key});

  @override
  State<CubeStreamScreen> createState() => _CubeStreamScreenState();
}

class _CubeStreamScreenState extends State<CubeStreamScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  bool _isInitialized = false;
  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    _initializeRenderer();
  }

  Future<void> _initializeRenderer() async {
    await _localRenderer.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  Future<void> _toggleStreaming() async {
    final streamerProvider =
        provider_pkg.Provider.of<StreamerProvider>(context, listen: false);

    if (!_isStreaming) {
      // Start streaming
      await streamerProvider.initialize();
      setState(() {
        _isStreaming = true;
      });
    } else {
      // Stop streaming
      streamerProvider.dispose();
      setState(() {
        _isStreaming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'CUBE□CAM',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          if (_isStreaming)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: Colors.white, size: 8),
                  SizedBox(width: 6),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: provider_pkg.Consumer<StreamerProvider>(
          builder: (context, streamerProvider, child) {
            if (!_isInitialized) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            // Set the stream when available
            if (streamerProvider.localStream != null) {
              _localRenderer.srcObject = streamerProvider.localStream;
            }

            return Column(
              children: [
                // Video preview
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isStreaming
                            ? AppColors.primary
                            : AppColors.borderPrimary,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: _isStreaming && streamerProvider.localStream != null
                          ? RTCVideoView(
                              _localRenderer,
                              objectFit:
                                  RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                              mirror: true,
                            )
                          : Container(
                              color: AppColors.surface,
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.videocam_outlined,
                                      size: 64,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Start streaming to go live',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),

                // Stream info
                if (_isStreaming)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderPrimary,
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stream URL',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'stream.rarecube.tv',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Controls
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Camera toggle
                      if (_isStreaming)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => streamerProvider.toggleCamera(),
                            icon: const Icon(Icons.flip_camera_ios),
                            label: const Text('Flip'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: BorderSide(
                                color: AppColors.borderPrimary,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),

                      if (_isStreaming) const SizedBox(width: 12),

                      // Start/Stop streaming button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _toggleStreaming,
                          icon: Icon(
                            _isStreaming ? Icons.stop : Icons.play_arrow,
                          ),
                          label: Text(
                            _isStreaming ? 'Stop Streaming' : 'Start Streaming',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isStreaming
                                ? Colors.red
                                : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
