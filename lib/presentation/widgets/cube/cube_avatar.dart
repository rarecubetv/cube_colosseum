import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

/// Predefined size presets for cube avatars
enum CubeAvatarSize {
  tiny(24),
  small(48),
  medium(64),
  large(80),
  xlarge(120);

  final double value;
  const CubeAvatarSize(this.value);
}

/// 3D rotating cube avatar widget - Reusable profile avatar component
///
/// Features:
/// - Displays user profile image on all 4 sides of a rotating cube
/// - Smooth 3D rotation animation with perspective
/// - Dynamic shadow effects for depth
/// - Colored borders per face (green, blue, orange, red)
/// - Responsive sizing with predefined size presets
/// - Optional animation control
///
/// Usage Examples:
/// ```dart
/// // Default size (80x80)
/// CubeAvatar(imageUrl: user.avatarUrl)
///
/// // With custom size
/// CubeAvatar(imageUrl: user.avatarUrl, size: 120)
///
/// // With size preset
/// CubeAvatar.preset(imageUrl: user.avatarUrl, sizePreset: CubeAvatarSize.small)
///
/// // Disable animation
/// CubeAvatar(imageUrl: user.avatarUrl, animate: false)
///
/// // Custom animation speed
/// CubeAvatar(imageUrl: user.avatarUrl, animationDuration: Duration(seconds: 4))
/// ```
class CubeAvatar extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final Duration animationDuration;
  final bool animate;
  final double borderWidth;
  final double perspective;

  const CubeAvatar({
    super.key,
    this.imageUrl,
    this.size = 80,
    this.animationDuration = const Duration(seconds: 8),
    this.animate = true,
    this.borderWidth = 2.0,
    this.perspective = 0.001,
  });

  /// Create a cube avatar with a predefined size preset
  CubeAvatar.preset({
    super.key,
    this.imageUrl,
    required CubeAvatarSize sizePreset,
    this.animationDuration = const Duration(seconds: 8),
    this.animate = true,
    this.borderWidth = 2.0,
    this.perspective = 0.001,
  }) : size = sizePreset.value;

  @override
  State<CubeAvatar> createState() => _CubeAvatarState();
}

class _CubeAvatarState extends State<CubeAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.animate
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final animationRotationY = _controller.value * 2 * math.pi;

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, widget.perspective)
                    ..rotateY(animationRotationY),
                  alignment: Alignment.center,
                  child: _buildCube(),
                );
              },
            )
          : Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, widget.perspective)
                ..rotateY(math.pi / 4), // Static 45-degree angle
              alignment: Alignment.center,
              child: _buildCube(),
            ),
    );
  }

  Widget _buildCube() {
    final halfSize = widget.size / 2;

    // 4-sided square cube with proper Z-axis translation
    return Stack(
      children: [
        // Front face (translateZ forward)
        _buildCubeFace(
          halfSize: halfSize,
          yRot: 0,
          moveZ: true,
          borderColor: AppColors.primary.withOpacity(0.6),
        ),
        // Right face
        _buildCubeFace(
          halfSize: halfSize,
          yRot: math.pi / 2,
          moveZ: true,
          borderColor: AppColors.info.withOpacity(0.6),
        ),
        // Back face (translateZ backward)
        _buildCubeFace(
          halfSize: halfSize,
          yRot: math.pi,
          moveZ: false,
          borderColor: AppColors.warning.withOpacity(0.6),
        ),
        // Left face
        _buildCubeFace(
          halfSize: halfSize,
          yRot: -math.pi / 2,
          moveZ: true,
          borderColor: AppColors.error.withOpacity(0.6),
        ),
      ],
    );
  }

  Widget _buildCubeFace({
    required double halfSize,
    required double yRot,
    required bool moveZ,
    required Color borderColor,
  }) {
    // Calculate shadow based on rotation for depth effect
    final shadow = _calculateShadow(yRot);
    final borderRadius = widget.size * 0.075; // 7.5% of size

    // Debug mode: use solid colors instead of images
    final isDebugMode = widget.imageUrl == 'DEBUG';

    // Get face color based on rotation (for debug mode)
    Color getFaceColor() {
      if (yRot == 0) return AppColors.primary; // Green - front
      if (yRot == math.pi / 2) return AppColors.info; // Blue - right
      if (yRot == math.pi) return AppColors.warning; // Orange - back
      if (yRot == -math.pi / 2) return AppColors.error; // Red - left
      return AppColors.overlayLight;
    }

    return Transform(
      transform: Matrix4.identity()
        ..rotateY(yRot)
        ..translate(0.0, 0.0, moveZ ? -halfSize : halfSize),
      alignment: Alignment.center,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: isDebugMode ? getFaceColor() : AppColors.overlayLight,
          border: Border.all(
            color: borderColor,
            width: widget.borderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        foregroundDecoration: BoxDecoration(
          color: Colors.black.withOpacity(shadow),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: isDebugMode
            ? null
            : ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius * 0.7),
                child: widget.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: widget.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.overlayLight,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.overlayLight,
                          child: Icon(
                            Icons.person,
                            color: AppColors.textTertiary,
                            size: widget.size * 0.5,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: AppColors.textTertiary,
                        size: widget.size * 0.5,
                      ),
              ),
      ),
    );
  }

  double _calculateShadow(double rotation) {
    const double maxShadow = 0.3;
    const double halfPi = math.pi / 2;
    const double oneHalfPi = math.pi + math.pi / 2;

    final r = rotation.abs() % (math.pi * 2);

    if (r < halfPi) {
      return _map(r, 0, halfPi, 0, maxShadow);
    } else if (r > oneHalfPi) {
      return maxShadow - _map(r, oneHalfPi, math.pi * 2, 0, maxShadow);
    } else if (r < math.pi) {
      return maxShadow - _map(r, halfPi, math.pi, 0, maxShadow);
    }

    return _map(r, math.pi, oneHalfPi, 0, maxShadow);
  }

  double _map(double value, double iStart, double iEnd, double oStart, double oEnd) {
    return ((oEnd - oStart) / (iEnd - iStart)) * (value - iStart) + oStart;
  }
}

// ============================================================================
// Convenience Widgets - Pre-configured cube avatars for common use cases
// ============================================================================

/// Tiny cube avatar (24x24) - For compact UI elements
///
/// Usage:
/// ```dart
/// CubeAvatarTiny(imageUrl: user.avatarUrl)
/// ```
class CubeAvatarTiny extends StatelessWidget {
  final String? imageUrl;
  final bool animate;

  const CubeAvatarTiny({
    super.key,
    this.imageUrl,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return CubeAvatar(
      imageUrl: imageUrl,
      size: CubeAvatarSize.tiny.value,
      animate: animate,
      borderWidth: 1.0,
    );
  }
}

/// Small cube avatar (48x48) - For list items and compact layouts
///
/// Usage:
/// ```dart
/// CubeAvatarSmall(imageUrl: user.avatarUrl)
/// ```
class CubeAvatarSmall extends StatelessWidget {
  final String? imageUrl;
  final bool animate;

  const CubeAvatarSmall({
    super.key,
    this.imageUrl,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return CubeAvatar(
      imageUrl: imageUrl,
      size: CubeAvatarSize.small.value,
      animate: animate,
    );
  }
}

/// Medium cube avatar (64x64) - For standard profile displays
///
/// Usage:
/// ```dart
/// CubeAvatarMedium(imageUrl: user.avatarUrl)
/// ```
class CubeAvatarMedium extends StatelessWidget {
  final String? imageUrl;
  final bool animate;

  const CubeAvatarMedium({
    super.key,
    this.imageUrl,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return CubeAvatar(
      imageUrl: imageUrl,
      size: CubeAvatarSize.medium.value,
      animate: animate,
    );
  }
}

/// Large cube avatar (80x80) - Default size for profile headers
///
/// Usage:
/// ```dart
/// CubeAvatarLarge(imageUrl: user.avatarUrl)
/// ```
class CubeAvatarLarge extends StatelessWidget {
  final String? imageUrl;
  final bool animate;

  const CubeAvatarLarge({
    super.key,
    this.imageUrl,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return CubeAvatar(
      imageUrl: imageUrl,
      size: CubeAvatarSize.large.value,
      animate: animate,
    );
  }
}

/// Extra large cube avatar (120x120) - For featured profiles
///
/// Usage:
/// ```dart
/// CubeAvatarXLarge(imageUrl: user.avatarUrl)
/// ```
class CubeAvatarXLarge extends StatelessWidget {
  final String? imageUrl;
  final bool animate;

  const CubeAvatarXLarge({
    super.key,
    this.imageUrl,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return CubeAvatar(
      imageUrl: imageUrl,
      size: CubeAvatarSize.xlarge.value,
      animate: animate,
    );
  }
}
