import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

/// 3D rotating cube avatar widget
/// Matches the web app's cube avatar animation
/// Shows user avatar on all 6 faces with rotation animation
class CubeAvatar extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final Duration animationDuration;

  const CubeAvatar({
    super.key,
    this.imageUrl,
    this.size = 80,
    this.animationDuration = const Duration(seconds: 8),
  });

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
    )..repeat();
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate rotation
          final baseRotationX = -15 * math.pi / 180;
          final baseRotationY = 25 * math.pi / 180;
          final animationRotationY = _controller.value * 2 * math.pi;
          final totalRotationY = baseRotationY + animationRotationY;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002) // Stronger perspective
              ..rotateX(baseRotationX)
              ..rotateY(totalRotationY),
            alignment: Alignment.center,
            child: _buildCube(),
          );
        },
      ),
    );
  }

  Widget _buildCube() {
    final halfSize = widget.size / 2;

    // Only show 3 visible faces at a time to avoid see-through issues
    return Stack(
      children: [
        // Front face
        _buildCubeFace(
          halfSize: halfSize,
          rotateX: 0,
          rotateY: 0,
        ),
        // Right face
        _buildCubeFace(
          halfSize: halfSize,
          rotateX: 0,
          rotateY: math.pi / 2,
        ),
        // Left face
        _buildCubeFace(
          halfSize: halfSize,
          rotateX: 0,
          rotateY: -math.pi / 2,
        ),
        // Top face
        _buildCubeFace(
          halfSize: halfSize,
          rotateX: -math.pi / 2,
          rotateY: 0,
        ),
        // Bottom face
        _buildCubeFace(
          halfSize: halfSize,
          rotateX: math.pi / 2,
          rotateY: 0,
        ),
        // Back face
        _buildCubeFace(
          halfSize: halfSize,
          rotateX: 0,
          rotateY: math.pi,
        ),
      ],
    );
  }

  Widget _buildCubeFace({
    required double halfSize,
    required double rotateX,
    required double rotateY,
  }) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateY(rotateY)
        ..rotateX(rotateX)
        ..translate(0.0, 0.0, halfSize),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: AppColors.overlayLight,
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: widget.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: widget.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.overlayLight,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.overlayLight,
                    child: const Icon(
                      Icons.person,
                      color: AppColors.textTertiary,
                    ),
                  ),
                )
              : const Icon(
                  Icons.person,
                  color: AppColors.textTertiary,
                ),
        ),
      ),
    );
  }
}

/// Smaller cube avatar variant for list items
class CubeAvatarSmall extends StatelessWidget {
  final String? imageUrl;

  const CubeAvatarSmall({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CubeAvatar(
      imageUrl: imageUrl,
      size: 48,
      animationDuration: const Duration(seconds: 8),
    );
  }
}

/// Wall layout cube avatar (for stream feed)
class CubeAvatarWall extends StatelessWidget {
  final String? imageUrl;

  const CubeAvatarWall({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CubeAvatar(
      imageUrl: imageUrl,
      size: 32,
      animationDuration: const Duration(seconds: 8),
    );
  }
}
