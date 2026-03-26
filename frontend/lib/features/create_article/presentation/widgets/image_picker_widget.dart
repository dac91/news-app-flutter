import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/design_tokens.dart';

/// A tappable image picker area for article thumbnail selection.
///
/// Displays either:
/// - A placeholder with an "Add Image" prompt (when no image is selected)
/// - An uploading indicator (when [isUploading] is true)
/// - A preview of the selected image file
/// - A preview of the uploaded image URL
///
/// Design follows the "grandmother test": large tap target, clear visual
/// affordance, obvious state feedback.
class ImagePickerWidget extends StatelessWidget {
  final File? selectedImage;
  final String? uploadedImageUrl;
  final bool isUploading;
  final VoidCallback onTap;

  const ImagePickerWidget({
    Key? key,
    this.selectedImage,
    this.uploadedImageUrl,
    required this.isUploading,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: isUploading ? null : onTap,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: AppRadius.mdBorder,
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isUploading) {
      return _buildUploadingIndicator(context);
    }
    if (selectedImage != null) {
      return _buildFilePreview(context);
    }
    if (uploadedImageUrl != null) {
      return _buildUrlPreview(context);
    }
    return _buildPlaceholder(context);
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined,
            size: 48, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(height: 8),
        Text(
          'Tap to add thumbnail image',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'JPG, PNG \u2022 Max 5 MB',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 16),
          const SizedBox(height: 12),
          Text(
            'Uploading image...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(selectedImage!, fit: BoxFit.cover),
        _buildChangeOverlay(context),
      ],
    );
  }

  Widget _buildUrlPreview(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          uploadedImageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        _buildUploadedBadge(context),
        _buildChangeOverlay(context),
      ],
    );
  }

  Widget _buildUploadedBadge(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: AppRadius.mdBorder,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle,
                color: theme.colorScheme.onPrimaryContainer, size: 14),
            const SizedBox(width: 4),
            Text(
              'Uploaded',
              style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeOverlay(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: theme.colorScheme.surface.withOpacity(0.75),
        child: Text(
          'Tap to change image',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
