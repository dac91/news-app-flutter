import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/core/services/draft_service.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_cubit.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_state.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/article_text_field.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/image_picker_widget.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/widgets/submit_article_button.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

/// Screen for creating and editing articles.
///
/// Flow:
/// 1. User fills in title, description, content, author fields
/// 2. User taps image area to pick a thumbnail from gallery/camera
/// 3. Image is uploaded to Cloud Storage immediately on selection
/// 4. User taps "Publish Article" — fields + image URL are submitted to Firestore
/// 5. On success, a confirmation is shown and user can navigate back
///
/// Supports auto-save drafts: if the user leaves the page with unsaved
/// content, a draft is persisted to SharedPreferences. On next visit,
/// the user is offered to restore it.
///
/// When [articleToEdit] is provided, the screen operates in edit mode —
/// fields are pre-filled and submission calls [updateArticle] instead.
class CreateArticlePage extends StatefulWidget {
  final FirebaseArticleEntity? articleToEdit;

  /// When false, the back button is hidden (used when shown as a tab).
  final bool showBackButton;

  const CreateArticlePage({
    Key? key,
    this.articleToEdit,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController();
  final _draftService = sl<DraftService>();

  File? _selectedImage;
  String? _uploadedImageUrl;
  String? _selectedCategory;
  Timer? _autoSaveTimer;

  bool get _isEditMode => widget.articleToEdit != null;

  static const List<String> _categories = [
    'General',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _prefillFromArticle();
    } else {
      _prefillAuthorFromAuth();
      _checkForDraft();
    }
    _setupAutoSave();
  }

  /// Pre-fills all fields from the article being edited.
  void _prefillFromArticle() {
    final article = widget.articleToEdit!;
    _titleController.text = article.title;
    _descriptionController.text = article.description;
    _contentController.text = article.content;
    _authorController.text = article.author;
    _uploadedImageUrl = article.thumbnailUrl;
    _selectedCategory = article.category;
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _saveDraftIfNeeded();
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _setupAutoSave() {
    // Auto-save every 10 seconds if there's content
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _saveDraftIfNeeded();
    });
  }

  /// Pre-fills the author field with the authenticated user's display name.
  void _prefillAuthorFromAuth() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final name = authState.user.displayName;
      if (name != null && name.isNotEmpty) {
        _authorController.text = name;
      }
    }
  }

  Future<void> _checkForDraft() async {
    final draft = await _draftService.loadDraft();
    if (draft == null || !mounted) return;

    final hasContent = draft.values.any((v) => v.isNotEmpty);
    if (!hasContent) return;

    final shouldRestore = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Restore Draft?'),
        content: const Text(
          'You have an unsaved draft. Would you like to restore it?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
              _draftService.clearDraft();
            },
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Restore',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (shouldRestore == true && mounted) {
      setState(() {
        _titleController.text = draft['title'] ?? '';
        _descriptionController.text = draft['description'] ?? '';
        _contentController.text = draft['content'] ?? '';
        _authorController.text = draft['author'] ?? '';
        _uploadedImageUrl = draft['imageUrl'];
      });
    }
  }

  /// Whether the form has meaningful content worth saving as a draft.
  /// Excludes the author field since it's auto-filled from auth.
  bool get _hasMeaningfulContent =>
      _titleController.text.trim().isNotEmpty ||
      _descriptionController.text.trim().isNotEmpty ||
      _contentController.text.trim().isNotEmpty ||
      _uploadedImageUrl != null;

  void _saveDraftIfNeeded() {
    // Don't save drafts when editing an existing article
    if (_isEditMode) return;

    if (_hasMeaningfulContent) {
      _draftService.saveDraft(
        title: _titleController.text,
        description: _descriptionController.text,
        content: _contentController.text,
        author: _authorController.text,
        imageUrl: _uploadedImageUrl,
      );
    }
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
      leading: widget.showBackButton
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
              child: Icon(Ionicons.chevron_back,
                  color: Theme.of(context).appBarTheme.iconTheme?.color),
            )
          : null,
      automaticallyImplyLeading: widget.showBackButton,
      title: Text(
        _isEditMode ? 'Edit Article' : 'Create Article',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.drafts_outlined),
          tooltip: 'Save draft',
          onPressed: () {
            if (_hasMeaningfulContent) {
              _saveDraftIfNeeded();
              _showSnackBar('Draft saved — it will be restored next time you open this page');
            } else {
              _showSnackBar('Add some content before saving a draft');
            }
          },
        ),
      ],
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
        _buildCategoryDropdown(),
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

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: const InputDecoration(
          labelText: 'Category (optional)',
          border: OutlineInputBorder(),
        ),
        items: _categories.map((cat) {
          return DropdownMenuItem(value: cat.toLowerCase(), child: Text(cat));
        }).toList(),
        onChanged: (value) => setState(() => _selectedCategory = value),
      ),
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

    final cubit = context.read<CreateArticleCubit>();

    if (_isEditMode) {
      cubit.updateArticle(
        id: widget.articleToEdit!.id!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        content: _contentController.text.trim(),
        author: _authorController.text.trim(),
        imageUrl: _uploadedImageUrl!,
        category: _selectedCategory,
        createdAt: widget.articleToEdit!.createdAt,
      );
    } else {
      cubit.submitArticle(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        content: _contentController.text.trim(),
        author: _authorController.text.trim(),
        imageUrl: _uploadedImageUrl!,
        category: _selectedCategory,
      );
    }
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
      // Clear draft on successful publish
      _draftService.clearDraft();
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
    final isEdit = _isEditMode;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 8),
            Text(isEdit ? 'Updated!' : 'Published!'),
          ],
        ),
        content: Text(
          isEdit
              ? 'Your article has been updated successfully.'
              : 'Your article has been published successfully.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: const Text(
              'Done',
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
