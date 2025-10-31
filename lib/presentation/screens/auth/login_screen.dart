import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/cube/cube_avatar.dart';
import '../../providers/user_provider.dart';
import '../../widgets/solana/solana_wallet_button.dart';

/// Login screen with video background and Seeker wallet integration
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late VideoPlayerController _backgroundController;
  late VideoPlayerController _cubesController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideos();
  }

  Future<void> _initializeVideos() async {
    _backgroundController = VideoPlayerController.asset('assets/videos/new-internet.mp4')
      ..setLooping(true)
      ..setVolume(0);

    _cubesController = VideoPlayerController.asset('assets/videos/cubes.mp4')
      ..setLooping(true)
      ..setVolume(0);

    try {
      await Future.wait([
        _backgroundController.initialize(),
        _cubesController.initialize(),
      ]);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Start playing after state is updated
        await _backgroundController.play();
        await _cubesController.play();

        // Add listener to force rebuild on video updates
        _backgroundController.addListener(() {
          if (mounted) setState(() {});
        });
        _cubesController.addListener(() {
          if (mounted) setState(() {});
        });
      }
    } catch (e) {
      print('Error initializing videos: $e');
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cubesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background video
          if (_isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _backgroundController.value.size.width,
                  height: _backgroundController.value.size.height,
                  child: VideoPlayer(_backgroundController),
                ),
              ),
            ),

          // Dark overlay - lighter to let video show through
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Content
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Top branding
              const SizedBox(height: 60),
              Text(
                'RARECUBE',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'SOLANA SEEKER',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: AppColors.primary,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Cubes video - no glass background
              if (_isInitialized)
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _cubesController.value.size.width,
                        height: _cubesController.value.size.height,
                        child: VideoPlayer(_cubesController),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              Text(
                'Use your Solana wallet to sign in.\nYour Genesis Token name will be your identity.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Primary CTA - Solana Wallet Connect
              SolanaWalletButton(
                onConnected: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Welcome to RareCube!'),
                      duration: Duration(seconds: 2),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),

              const Spacer(),

              // Footer info
              Text(
                'Built for Solana Mobile',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
          ),
        ],
      ),
    );
  }

  void _handleTwitterLogin(BuildContext context) {
    // TODO: Implement actual Twitter OAuth flow
    // For now, navigate directly to home to demo the app
    context.go('/home');
  }

  void _handleAgentTap(BuildContext context) {
    // TODO: Navigate to agent page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CUBE Agent - Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// User card widget for the carousel
class _UserCard extends StatelessWidget {
  final String name;
  final String badge;
  final String? avatarUrl;

  const _UserCard({
    required this.name,
    required this.badge,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          // Cube Avatar
          CubeAvatar(
            imageUrl: avatarUrl,
            size: 80,
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.4),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              badge.toLowerCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
