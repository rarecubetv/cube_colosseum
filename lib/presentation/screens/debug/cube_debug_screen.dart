import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/cube/cube_avatar.dart';

/// Debug screen to test and showcase cube avatar variants
class CubeDebugScreen extends StatelessWidget {
  const CubeDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Cube Avatar Debug',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Cube Avatar Components',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Testing all cube avatar variants and sizes with solid colors',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            // All Sizes Grid - Using solid color for debugging
            _buildSection(
              'Size Variants',
              'All predefined size presets with solid colors',
              Column(
                children: [
                  _buildCubeRow('Tiny (24px)', const CubeAvatarTiny(imageUrl: 'DEBUG')),
                  _buildCubeRow('Small (48px)', const CubeAvatarSmall(imageUrl: 'DEBUG')),
                  _buildCubeRow('Medium (64px)', const CubeAvatarMedium(imageUrl: 'DEBUG')),
                  _buildCubeRow('Large (80px)', const CubeAvatarLarge(imageUrl: 'DEBUG')),
                  _buildCubeRow('XLarge (120px)', const CubeAvatarXLarge(imageUrl: 'DEBUG')),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Custom Sizes
            _buildSection(
              'Custom Sizes',
              'Using direct size parameter with solid colors',
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildCubeColumn('32px', const CubeAvatar(size: 32, imageUrl: 'DEBUG')),
                  _buildCubeColumn('64px', const CubeAvatar(size: 64, imageUrl: 'DEBUG')),
                  _buildCubeColumn('96px', const CubeAvatar(size: 96, imageUrl: 'DEBUG')),
                  _buildCubeColumn('150px', const CubeAvatar(size: 150, imageUrl: 'DEBUG')),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Animation Controls
            _buildSection(
              'Animation Control',
              'Animated vs Static cubes',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCubeColumn(
                    'Animated',
                    const CubeAvatarLarge(animate: true, imageUrl: 'DEBUG'),
                  ),
                  _buildCubeColumn(
                    'Static',
                    const CubeAvatarLarge(animate: false, imageUrl: 'DEBUG'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Custom Parameters
            _buildSection(
              'Custom Parameters',
              'Border width and perspective adjustments',
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildCubeColumn(
                    'Thin Border',
                    const CubeAvatar(size: 80, borderWidth: 0.5, imageUrl: 'DEBUG'),
                  ),
                  _buildCubeColumn(
                    'Thick Border',
                    const CubeAvatar(size: 80, borderWidth: 4, imageUrl: 'DEBUG'),
                  ),
                  _buildCubeColumn(
                    'More Perspective',
                    const CubeAvatar(size: 80, perspective: 0.003, imageUrl: 'DEBUG'),
                  ),
                  _buildCubeColumn(
                    'Less Perspective',
                    const CubeAvatar(size: 80, perspective: 0.0005, imageUrl: 'DEBUG'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // With Images
            _buildSection(
              'With Profile Images',
              'Testing with actual image URLs',
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildCubeColumn(
                    'User 1',
                    const CubeAvatar(
                      size: 80,
                      imageUrl: 'https://i.pravatar.cc/150?img=1',
                    ),
                  ),
                  _buildCubeColumn(
                    'User 2',
                    const CubeAvatar(
                      size: 80,
                      imageUrl: 'https://i.pravatar.cc/150?img=2',
                    ),
                  ),
                  _buildCubeColumn(
                    'User 3',
                    const CubeAvatar(
                      size: 80,
                      imageUrl: 'https://i.pravatar.cc/150?img=3',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Speed Variants
            _buildSection(
              'Animation Speed',
              'Different rotation speeds',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCubeColumn(
                    'Fast (2s)',
                    const CubeAvatar(
                      size: 80,
                      imageUrl: 'DEBUG',
                      animationDuration: Duration(seconds: 2),
                    ),
                  ),
                  _buildCubeColumn(
                    'Normal (8s)',
                    const CubeAvatar(
                      size: 80,
                      imageUrl: 'DEBUG',
                      animationDuration: Duration(seconds: 8),
                    ),
                  ),
                  _buildCubeColumn(
                    'Slow (15s)',
                    const CubeAvatar(
                      size: 80,
                      imageUrl: 'DEBUG',
                      animationDuration: Duration(seconds: 15),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderPrimary,
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildCubeRow(String label, Widget cube) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          cube,
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.borderSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCubeColumn(String label, Widget cube) {
    return Column(
      children: [
        cube,
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
