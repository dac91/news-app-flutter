import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_cubit.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_state.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/article_text_field.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/image_picker_widget.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/submit_article_button.dart';

/// Screen for creating and publishing a new article.
///
/// Flow:
/// 1. User fills in title, description, content, author fields
/// 2. User taps image area to pick a thumbnail from gallery/camera
/// 3. Image is uploaded to Cloud Storage immediately on selection
/// 4. User taps "Publish Article" — fields + image URL are submitted to Firestore
/// 5. On success, a confirmation is shown and user can navigate back
///
/// Validation enforces field lengths matching the Firestore schema rules
/// (see backend/docs/DB_SCHEMA.md).
class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({Key? key}) : super(key: key);

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController();

  File? _selectedImage;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateArticleCubit, CreateArticleState>(
      listener: _onStateChanged,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: const Icon(Ionicons.chevron_back, color: Colors.black),
      ),
      title: const Text(
        'Create Article',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              _buildFormFields(),
              const SizedBox(height: 8),
              _buildSubmitButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return BlocBuilder<CreateArticleCubit, CreateArticleState>(
      builder: (context, state) {
        final isUploading = state is CreateArticleImageUploading;
        return ImagePickerWidget(
          selectedImage: _selectedImage,
          uploadedImageUrl: _uploadedImageUrl,
          isUploading: isUploading,
          onTap: _pickImage,
        );
      },
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        ArticleTextField(
          controller: _titleController,
          label: 'Title',
          hint: 'Enter article title',
          maxLength: 200,
        ),
        ArticleTextField(
          controller: _descriptionController,
          label: 'Description',
          hint: 'A brief summary of the article',
          maxLength: 500,
          maxLines: 3,
        ),
        ArticleTextField(
          controller: _contentController,
          label: 'Content',
          hint: 'Write the full article content here...',
          maxLength: 10000,
          maxLines: 8,
          textInputAction: TextInputAction.newline,
        ),
        ArticleTextField(
          controller: _authorController,
          label: 'Author',
          hint: 'Author name',
          maxLength: 100,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<CreateArticleCubit, CreateArticleState>(
      builder: (context, state) {
        final isSubmitting = state is CreateArticleSubmitting;
        final isUploading = state is CreateArticleImageUploading;
        final hasImage = _uploadedImageUrl != null;

        return SubmitArticleButton(
          isLoading: isSubmitting || isUploading,
          onPressed: hasImage ? _onSubmit : null,
        );
      },
    );
  }

  // --- Actions ---

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final source = await _showImageSourceDialog();
    if (source == null) return;

    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    setState(() {
      _selectedImage = file;
      _uploadedImageUrl = null;
    });

    if (!mounted) return;
    context.read<CreateArticleCubit>().uploadImage(file);
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_uploadedImageUrl == null) {
      _showSnackBar('Please upload a thumbnail image first');
      return;
    }

    context.read<CreateArticleCubit>().submitArticle(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          content: _contentController.text.trim(),
          author: _authorController.text.trim(),
          imageUrl: _uploadedImageUrl!,
        );
  }

  // --- State listener ---

  void _onStateChanged(BuildContext context, CreateArticleState state) {
    if (state is CreateArticleImageUploaded) {
      setState(() {
        _uploadedImageUrl = state.imageUrl;
      });
      _showSnackBar('Image uploaded successfully');
    }

    if (state is CreateArticleSuccess) {
      _showSuccessDialog();
    }

    if (state is CreateArticleError) {
      // Preserve imageUrl if it existed before the error
      if (state.imageUrl != null) {
        setState(() {
          _uploadedImageUrl = state.imageUrl;
        });
      }
      _showSnackBar(state.error.message ?? 'An error occurred');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Published!'),
          ],
        ),
        content: const Text(
          'Your article has been published successfully.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to news list
            },
            child: const Text(
              'Back to News',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
