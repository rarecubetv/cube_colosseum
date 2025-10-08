import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// Stream creation screen matching pages/stream/create.js
/// Multi-step form for creating stream cards
class StreamCreateScreen extends ConsumerStatefulWidget {
  const StreamCreateScreen({super.key});

  @override
  ConsumerState<StreamCreateScreen> createState() => _StreamCreateScreenState();
}

class _StreamCreateScreenState extends ConsumerState<StreamCreateScreen> {
  int _currentStep = 0;

  // Form state
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _category = '';

  final List<Map<String, String>> _steps = [
    {'title': 'Banner', 'description': 'Upload your banner media'},
    {'title': 'Details', 'description': 'Add title and description'},
    {'title': 'Links', 'description': 'Connect your socials'},
    {'title': 'Token', 'description': 'Attach a token (optional)'},
    {'title': 'Preview', 'description': 'Review your card'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        } else {
                          context.pop();
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    // Title
                    const Expanded(
                      child: Text(
                        'Create Stream Card',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.01,
                        ),
                      ),
                    ),
                    // Step indicator
                    Text(
                      '${_currentStep + 1}/${_steps.length}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Progress bar
          Container(
            height: 2,
            color: AppColors.borderPrimary,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentStep + 1) / _steps.length,
              child: Container(
                color: AppColors.primary,
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step title
                  Text(
                    _steps[_currentStep]['title']!,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.02,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _steps[_currentStep]['description']!,
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Step content
                  _buildStepContent(),
                ],
              ),
            ),
          ),

          // Footer actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentStep == _steps.length - 1 ? 'Publish' : 'Next',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.01,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBannerStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildLinksStep();
      case 3:
        return _buildTokenStep();
      case 4:
        return _buildPreviewStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBannerStep() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.overlayLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderPrimary,
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Image picker
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image picker - Coming soon!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 48,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                'Tap to upload',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Images, Videos, or GIFs',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Title',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.01,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: _title,
            maxLength: 60,
            decoration: InputDecoration(
              hintText: 'Enter title',
              filled: true,
              fillColor: AppColors.overlayLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
            ),
            style: const TextStyle(fontSize: 17),
            onChanged: (value) => _title = value,
            validator: (value) {
              if (value == null || value.length < 3) {
                return 'Title must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Description
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.01,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: _description,
            maxLength: 280,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter description',
              filled: true,
              fillColor: AppColors.overlayLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
            ),
            style: const TextStyle(fontSize: 17),
            onChanged: (value) => _description = value,
            validator: (value) {
              if (value == null || value.length < 10) {
                return 'Description must be at least 10 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Category
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.01,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _category.isEmpty ? null : _category,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.overlayLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'gaming', child: Text('Gaming')),
              DropdownMenuItem(value: 'music', child: Text('Music')),
              DropdownMenuItem(value: 'art', child: Text('Art')),
              DropdownMenuItem(value: 'tech', child: Text('Tech')),
              DropdownMenuItem(value: 'finance', child: Text('Finance')),
              DropdownMenuItem(value: 'lifestyle', child: Text('Lifestyle')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _category = value);
              }
            },
            hint: const Text('Select category (optional)'),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksStep() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.link,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.4),
          ),
          const SizedBox(height: 20),
          const Text(
            'Social links',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Connect your social profiles',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add social link - Coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Social Link'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.overlayLight,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenStep() {
    return Center(
      child: Column(
        children: [
          Text(
            '🪙',
            style: TextStyle(
              fontSize: 64,
              color: AppColors.textTertiary.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Attach a token',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Optional: Link a token or NFT',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Token attachment - Coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Attach Token'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.overlayLight,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.overlayLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.borderPrimary,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner placeholder
              AspectRatio(
                aspectRatio: 19 / 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title.isEmpty ? 'Your title here' : _title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.01,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _description.isEmpty
                          ? 'Your description here'
                          : _description,
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (_category.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _category,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleNext() {
    if (_currentStep == 1) {
      // Validate form on details step
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }
    }

    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      // Publish
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stream card publishing - Coming soon!'),
          duration: Duration(seconds: 2),
        ),
      );
      context.pop();
    }
  }
}
