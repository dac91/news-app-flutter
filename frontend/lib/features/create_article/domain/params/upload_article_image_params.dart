import 'dart:io';

import 'package:equatable/equatable.dart';

/// Parameters for the [UploadArticleImageUseCase].
class UploadArticleImageParams extends Equatable {
  final File imageFile;

  const UploadArticleImageParams({required this.imageFile});

  @override
  List<Object?> get props => [imageFile.path];
}
