import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/common/bottom_nav.dart';
import '../../widgets/cube/cube_avatar.dart';
import '../../providers/stream_provider.dart';
import '../../providers/convex_provider.dart';

/// Provider to get file URL from storage ID
final fileUrlProvider = FutureProvider.family<String?, String>((ref, storageId) async {
  final client = ref.watch(convexClientProvider);
  try {
    return await client.getFileUrl(storageId);
  } catch (e) {
    print('Error fetching file URL for $storageId: $e');
    return null;
  }
});

/// Stream feed screen matching pages/stream.js
/// Shows two tabs: Streams (preview cards) and Wall (TikTok-style media)
class StreamFeedScreen extends ConsumerStatefulWidget {
  final bool embedded;

  const StreamFeedScreen({
    super.key,
    this.embedded = false,
  });

  @override
  ConsumerState<StreamFeedScreen> createState() => _StreamFeedScreenState();
}

class _StreamFeedScreenState extends ConsumerState<StreamFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Tab Navigation
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
            ),
            child: SafeArea(
              bottom: false,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textTertiary,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.01,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.01,
                ),
                tabs: const [
                  Tab(text: 'Streams'),
                  Tab(text: 'Wall'),
                ],
              ),
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // Streams Tab
                _StreamsTab(),

                // Wall Tab
                _WallTab(),
              ],
            ),
          ),
        ],
      ),

      // Create Stream FAB (only visible on Streams tab)
      floatingActionButton: _tabController.index == 0
          ? SizedBox(
              height: 36,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // Navigate to stream creation
                  context.push('/stream/create');
                },
                backgroundColor: AppColors.primary,
                elevation: 2,
                label: const Text(
                  '+ stream',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      bottomNavigationBar: widget.embedded ? null : const BottomNav(currentPage: 'stream'),
    );
  }
}

/// Streams tab - preview card layout
class _StreamsTab extends ConsumerWidget {
  const _StreamsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamCardsAsync = ref.watch(allStreamCardsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allStreamCardsProvider);
        await ref.read(allStreamCardsProvider.future);
      },
      color: AppColors.primary,
      child: streamCardsAsync.when(
        data: (streamCards) {
          if (streamCards.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '🟩',
                          style: TextStyle(
                            fontSize: 64,
                            color: AppColors.textTertiary.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No streams yet',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to create a stream card!',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: streamCards.length,
            itemBuilder: (context, index) {
              final card = streamCards[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _StreamPreviewCard(card: card),
              );
            },
          );
        },
        loading: () => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        error: (error, stack) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Text(
                  'Error loading streams',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
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

/// Preview card widget for streams tab
class _StreamPreviewCard extends ConsumerWidget {
  final dynamic card;

  const _StreamPreviewCard({required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerUrlAsync = ref.watch(fileUrlProvider(card.bannerStorageId));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.overlayLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderPrimary,
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to stream detail
            context.push('/stream/${card.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner (19:6 aspect ratio)
              AspectRatio(
                aspectRatio: 19 / 6,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: bannerUrlAsync.when(
                    data: (url) {
                      if (url == null) {
                        return Container(
                          color: AppColors.background,
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 48,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        );
                      }
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.background,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.background,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => Container(
                      color: AppColors.background,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    error: (error, stack) => Container(
                      color: AppColors.background,
                      child: const Center(
                        child: Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.01,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Subscribe button placeholder
                        Icon(
                          Icons.star_border,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Stats row
                    Row(
                      children: [
                        _StatItem(
                          icon: Icons.visibility_outlined,
                          count: card.views,
                        ),
                        const SizedBox(width: 16),
                        _StatItem(
                          icon: Icons.comment_outlined,
                          count: card.commentCount,
                        ),
                        const SizedBox(width: 16),
                        _StatItem(
                          icon: Icons.star_outline,
                          count: card.upvotes - card.downvotes,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;

  const _StatItem({
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Wall tab - TikTok-style media layout
class _WallTab extends ConsumerWidget {
  const _WallTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(allStreamMediaProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allStreamMediaProvider);
        await ref.read(allStreamMediaProvider.future);
      },
      color: AppColors.primary,
      child: mediaAsync.when(
        data: (mediaItems) {
          if (mediaItems.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '📸',
                          style: TextStyle(
                            fontSize: 64,
                            color: AppColors.textTertiary.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No media yet',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Media from stream galleries will appear here',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: mediaItems.length,
            itemBuilder: (context, index) {
              final media = mediaItems[index];
              return _WallMediaCard(media: media);
            },
          );
        },
        loading: () => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        error: (error, stack) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Text(
                  'Error loading media',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
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

/// Media card for wall tab (TikTok-style)
class _WallMediaCard extends StatelessWidget {
  final StreamMedia media;

  const _WallMediaCard({required this.media});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (media.streamCard != null) {
              context.push('/stream/${media.streamCard!.id}');
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media (9:16 aspect ratio for TikTok-style)
              AspectRatio(
                aspectRatio: 9 / 16,
                child: Container(
                  color: AppColors.overlayLight,
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),

              // Info section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Small cube avatar
                    const CubeAvatarTiny(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (media.streamCard != null)
                            Text(
                              media.streamCard!.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.01,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 2),
                          Text(
                            '${media.streamCard?.category ?? 'Uncategorized'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Like count
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          media.likes.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
