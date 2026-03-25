import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/upload_article_image_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/repository/create_article_repository.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/upload_article_image_usecase.dart';

class MockCreateArticleRepository extends Mock
    implements CreateArticleRepository {}

class FakeFirebaseArticleEntity extends Fake
    implements FirebaseArticleEntity {}

class FakeFile extends Fake implements File {
  @override
  String get path => '/fake/path/image.jpg';
}

void main() {
  late UploadArticleImageUseCase useCase;
  late MockCreateArticleRepository mockRepository;
  late FakeFile fakeFile;

  setUpAll(() {
    registerFallbackValue(FakeFile());
    registerFallbackValue(FakeFirebaseArticleEntity());
  });

  setUp(() {
    mockRepository = MockCreateArticleRepository();
    useCase = UploadArticleImageUseCase(mockRepository);
    fakeFile = FakeFile();
  });

  group('UploadArticleImageUseCase', () {
    test('returns DataSuccess with download URL on success', () async {
      // Arrange
      const tDownloadUrl = 'https://storage.example.com/media/articles/img.jpg';
      when(() => mockRepository.uploadArticleImage(any()))
          .thenAnswer((_) async => const DataSuccess(tDownloadUrl));

      // Act
      final result = await useCase(
        params: UploadArticleImageParams(imageFile: fakeFile),
      );

      // Assert
      expect(result, isA<DataSuccess<String>>());
      expect(result.data, equals(tDownloadUrl));
      verify(() => mockRepository.uploadArticleImage(any())).called(1);
    });

    test('returns DataFailed with AppException on failure', () async {
      // Arrange
      const tException = AppException(
        message: 'Upload failed',
        statusCode: 500,
        identifier: 'uploadArticleImage',
      );
      when(() => mockRepository.uploadArticleImage(any()))
          .thenAnswer((_) async => const DataFailed(tException));

      // Act
      final result = await useCase(
        params: UploadArticleImageParams(imageFile: fakeFile),
      );

      // Assert
      expect(result, isA<DataFailed<String>>());
      expect(result.error, equals(tException));
      expect(result.error!.message, equals('Upload failed'));
      verify(() => mockRepository.uploadArticleImage(any())).called(1);
    });

    test('passes the correct file to repository', () async {
      // Arrange
      when(() => mockRepository.uploadArticleImage(any()))
          .thenAnswer((_) async => const DataSuccess('url'));

      // Act
      await useCase(
        params: UploadArticleImageParams(imageFile: fakeFile),
      );

      // Assert
      final captured = verify(
        () => mockRepository.uploadArticleImage(captureAny()),
      ).captured.single as File;

      expect(captured.path, equals('/fake/path/image.jpg'));
    });
  });
}
