import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import '../../../core/theme/app_colors.dart';

/// Media upload widget for authenticated users
/// Supports: images, videos, GIFs, audio files
/// Features Apple HIG design with bottom sheet picker
class MediaUploadWidget extends StatelessWidget {
  final Function(File file, String mimeType) onMediaSelected;
  final List<String> allowedTypes;
  final Widget? child;

  const MediaUploadWidget({
    super.key,
    required this.onMediaSelected,
    this.allowedTypes = const ['image', 'video', 'audio'],
    this.child,
  });

  Future<void> _showMediaPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.overlayLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'Upload Media',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.01,
                ),
              ),

              const SizedBox(height: 20),

              // Camera option (images only)
              if (allowedTypes.contains('image'))
                _MediaOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Take Photo',
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickFromCamera(context);
                  },
                ),

              // Photo library (images)
              if (allowedTypes.contains('image'))
                _MediaOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Choose Photo',
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(context);
                  },
                ),

              // Video picker
              if (allowedTypes.contains('video'))
                _MediaOption(
                  icon: Icons.videocam_rounded,
                  label: 'Choose Video',
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickVideo(context);
                  },
                ),

              // File picker (any file)
              _MediaOption(
                icon: Icons.insert_drive_file_rounded,
                label: 'Choose File',
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFile(context);
                },
              ),

              const SizedBox(height: 8),

              // Cancel button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.overlayMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image != null) {
        final file = File(image.path);
        final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
        onMediaSelected(file, mimeType);
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to take photo: $e');
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        final file = File(image.path);
        final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
        onMediaSelected(file, mimeType);
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to pick image: $e');
      }
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final video = await picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video != null) {
        final file = File(video.path);
        final mimeType = lookupMimeType(video.path) ?? 'video/mp4';
        onMediaSelected(file, mimeType);
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to pick video: $e');
      }
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

        // Validate file type
        final typePrefix = mimeType.split('/').first;
        if (!allowedTypes.contains(typePrefix) && !allowedTypes.contains('any')) {
          if (context.mounted) {
            _showError(context, 'File type not allowed: $mimeType');
          }
          return;
        }

        onMediaSelected(file, mimeType);
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to pick file: $e');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMediaPicker(context),
      child: child ??
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.overlayLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderPrimary,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_rounded,
                  size: 24,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Upload Media',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _MediaOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MediaOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
