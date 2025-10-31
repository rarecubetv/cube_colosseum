import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/convex_client.dart';
import 'video_player_widget.dart';

/// Universal media viewer widget with lightbox support
/// Handles all media types: image, video, gif, audio
/// Features Apple HIG design with swipe to dismiss
class MediaViewerWidget extends StatelessWidget {
  final String storageId;
  final String mediaType;
  final String? mimeType;
  final ConvexClient convexClient;

  const MediaViewerWidget({
    super.key,
    required this.storageId,
    required this.mediaType,
    required this.convexClient,
    this.mimeType,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: convexClient.getFileUrl(storageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load media',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final url = snapshot.data!;

        switch (mediaType) {
          case 'image':
            return _ImageViewer(url: url);
          case 'video':
            return _VideoViewer(url: url);
          case 'gif':
            return _GifViewer(url: url);
          case 'audio':
            return _AudioViewer(url: url);
          default:
            return _UnsupportedMediaViewer();
        }
      },
    );
  }
}

/// Image viewer with pinch to zoom
class _ImageViewer extends StatelessWidget {
  final String url;

  const _ImageViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.black,
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Video viewer with native controls
class _VideoViewer extends StatelessWidget {
  final String url;

  const _VideoViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: VideoPlayerWidget(
          videoUrl: url,
          autoPlay: true,
          showControls: true,
        ),
      ),
    );
  }
}

/// GIF viewer (animated)
class _GifViewer extends StatelessWidget {
  final String url;

  const _GifViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.black,
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Audio player viewer
class _AudioViewer extends StatelessWidget {
  final String url;

  const _AudioViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.audiotrack_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Audio Player',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Unsupported media type
class _UnsupportedMediaViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.help_outline,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Unsupported media type',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen media lightbox
class MediaLightbox extends StatelessWidget {
  final String storageId;
  final String mediaType;
  final String? mimeType;
  final ConvexClient convexClient;

  const MediaLightbox({
    super.key,
    required this.storageId,
    required this.mediaType,
    required this.convexClient,
    this.mimeType,
  });

  static Future<void> show({
    required BuildContext context,
    required String storageId,
    required String mediaType,
    required ConvexClient convexClient,
    String? mimeType,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: MediaLightbox(
              storageId: storageId,
              mediaType: mediaType,
              convexClient: convexClient,
              mimeType: mimeType,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Media viewer
            GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 300) {
                  Navigator.of(context).pop();
                }
              },
              child: MediaViewerWidget(
                storageId: storageId,
                mediaType: mediaType,
                mimeType: mimeType,
                convexClient: convexClient,
              ),
            ),

            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
