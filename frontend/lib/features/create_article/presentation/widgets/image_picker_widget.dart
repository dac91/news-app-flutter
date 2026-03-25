import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isUploading) {
      return _buildUploadingIndicator();
    }
    if (selectedImage != null) {
      return _buildFilePreview();
    }
    if (uploadedImageUrl != null) {
      return _buildUrlPreview();
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined,
            size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          'Tap to add thumbnail image',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'JPG, PNG • Max 5 MB',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  Widget _buildUploadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(radius: 16),
          SizedBox(height: 12),
          Text(
            'Uploading image...',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(selectedImage!, fit: BoxFit.cover),
        _buildChangeOverlay(),
      ],
    );
  }

  Widget _buildUrlPreview() {
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
              color: Colors.grey.shade400,
            ),
          ),
        ),
        _buildUploadedBadge(),
        _buildChangeOverlay(),
      ],
    );
  }

  Widget _buildUploadedBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text(
              'Uploaded',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.black.withOpacity(0.5),
        child: const Text(
          'Tap to change image',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}
