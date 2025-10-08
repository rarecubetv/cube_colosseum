import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/cube/cube_avatar.dart';
import '../../providers/stream_provider.dart';
import 'stream_feed_screen.dart'; // Import to use shared fileUrlProvider

/// Stream detail screen matching pages/stream/[id].js
/// Shows full stream card with banner, details, stats, and media gallery
class StreamDetailScreen extends ConsumerWidget {
  final String streamId;

  const StreamDetailScreen({
    super.key,
    required this.streamId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamCardAsync = ref.watch(streamCardByIdProvider(streamId));
    final mediaItemsAsync = ref.watch(streamMediaByCardProvider(streamId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: streamCardAsync.when(
        data: (streamCard) {
          if (streamCard == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Stream not found',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App bar with back button
              SliverAppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // Share functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share - Coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Banner
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 19 / 6,
                  child: _BannerImage(storageId: streamCard.bannerStorageId),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with avatar and subscribe button
                      Row(
                        children: [
                          // Cube avatar
                          const CubeAvatar(size: 56),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        streamCard.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.01,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  streamCard.category ?? 'Uncategorized',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Subscribe button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.overlayLight,
                              border: Border.all(
                                color: AppColors.borderPrimary,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_border,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Description
                      Text(
                        streamCard.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Stats bar
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.overlayLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.borderPrimary,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatColumn(
                              icon: Icons.visibility_outlined,
                              label: 'Views',
                              value: streamCard.views.toString(),
                            ),
                            _StatColumn(
                              icon: Icons.comment_outlined,
                              label: 'Comments',
                              value: streamCard.commentCount.toString(),
                            ),
                            _StatColumn(
                              icon: Icons.star_outline,
                              label: 'Score',
                              value: (streamCard.upvotes - streamCard.downvotes).toString(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Vote buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_upward, size: 20),
                              label: Text(streamCard.upvotes.toString()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.overlayLight,
                                foregroundColor: AppColors.textPrimary,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: AppColors.borderPrimary,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_downward, size: 20),
                              label: Text(streamCard.downvotes.toString()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.overlayLight,
                                foregroundColor: AppColors.textPrimary,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: AppColors.borderPrimary,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Media gallery section
                      _MediaGallerySection(
                        mediaItemsAsync: mediaItemsAsync,
                      ),

                      const SizedBox(height: 32),

                      // Comments section
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.01,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Empty comments state
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.overlayLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.borderPrimary,
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 48,
                                color: AppColors.textTertiary.withOpacity(0.4),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 20),
              const Text(
                'Error loading stream',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Media gallery section widget
class _MediaGallerySection extends ConsumerWidget {
  final AsyncValue<List<StreamMedia>> mediaItemsAsync;

  const _MediaGallerySection({required this.mediaItemsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return mediaItemsAsync.when(
      data: (mediaItems) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Media',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.01,
                  ),
                ),
                Text(
                  '${mediaItems.length} items',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (mediaItems.isEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.overlayLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderPrimary,
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48,
                        color: AppColors.textTertiary.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No media yet',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: mediaItems.length,
                itemBuilder: (context, index) {
                  final media = mediaItems[index];
                  return _MediaThumbnail(media: media);
                },
              ),
          ],
        );
      },
      loading: () => Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.overlayLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderPrimary,
            width: 0.5,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      ),
      error: (error, stack) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.overlayLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderPrimary,
            width: 0.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Error loading media',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Media thumbnail widget
class _MediaThumbnail extends ConsumerWidget {
  final StreamMedia media;

  const _MediaThumbnail({required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlAsync = ref.watch(fileUrlProvider(media.storageId));

    return urlAsync.when(
      data: (url) {
        if (url == null) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.overlayLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.borderPrimary,
                width: 0.5,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 32,
                color: AppColors.textTertiary,
              ),
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: media.mediaType == 'gif'
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.overlayLight,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.overlayLight,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 32,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.overlayLight,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.overlayLight,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 32,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
        );
      },
      loading: () => Container(
        decoration: BoxDecoration(
          color: AppColors.overlayLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderPrimary,
            width: 0.5,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (error, stack) => Container(
        decoration: BoxDecoration(
          color: AppColors.overlayLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderPrimary,
            width: 0.5,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.error_outline,
            size: 32,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}

/// Banner image widget that loads from Convex storage
class _BannerImage extends ConsumerWidget {
  final String storageId;

  const _BannerImage({required this.storageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerUrlAsync = ref.watch(fileUrlProvider(storageId));

    return bannerUrlAsync.when(
      data: (url) {
        if (url == null) {
          return Container(
            color: AppColors.overlayLight,
            child: const Center(
              child: Icon(
                Icons.image,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
          );
        }

        return CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.overlayLight,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.overlayLight,
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        );
      },
      loading: () => Container(
        color: AppColors.overlayLight,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      ),
      error: (error, stack) => Container(
        color: AppColors.overlayLight,
        child: const Center(
          child: Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatColumn({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.01,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
