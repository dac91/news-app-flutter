import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/app_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/entities/firebase_article_entity.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/create_article_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/params/upload_article_image_params.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/create_article_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/update_article_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/domain/usecases/upload_article_image_usecase.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_cubit.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_state.dart';

// --- Mocks ---
class MockUploadArticleImageUseCase extends Mock
    implements UploadArticleImageUseCase {}

class MockCreateArticleUseCase extends Mock implements CreateArticleUseCase {}

class MockUpdateArticleUseCase extends Mock implements UpdateArticleUseCase {}

class MockFile extends Mock implements File {}

// --- Fakes for registerFallbackValue ---
class FakeUploadArticleImageParams extends Fake
    implements UploadArticleImageParams {}

class FakeCreateArticleParams extends Fake implements CreateArticleParams {}

class FakeFirebaseArticleEntity extends Fake
    implements FirebaseArticleEntity {}

void main() {
  late CreateArticleCubit cubit;
  late MockUploadArticleImageUseCase mockUploadImageUseCase;
  late MockCreateArticleUseCase mockCreateArticleUseCase;
  late MockUpdateArticleUseCase mockUpdateArticleUseCase;
  late MockFile mockFile;

  setUpAll(() {
    registerFallbackValue(FakeUploadArticleImageParams());
    registerFallbackValue(FakeCreateArticleParams());
    registerFallbackValue(FakeFirebaseArticleEntity());
  });

  setUp(() {
    mockUploadImageUseCase = MockUploadArticleImageUseCase();
    mockCreateArticleUseCase = MockCreateArticleUseCase();
    mockUpdateArticleUseCase = MockUpdateArticleUseCase();
    mockFile = MockFile();

    cubit = CreateArticleCubit(
      uploadImageUseCase: mockUploadImageUseCase,
      createArticleUseCase: mockCreateArticleUseCase,
      updateArticleUseCase: mockUpdateArticleUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('CreateArticleCubit', () {
    test('initial state is CreateArticleInitial', () {
      expect(cubit.state, const CreateArticleInitial());
    });

    group('uploadImage', () {
      test('emits [ImageUploading, ImageUploaded] on success', () async {
        const imageUrl = 'https://storage.example.com/image.jpg';

        when(() => mockUploadImageUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const DataSuccess(imageUrl));

        final expectedStates = <CreateArticleState>[
          const CreateArticleImageUploading(),
          const CreateArticleImageUploaded(imageUrl: imageUrl),
        ];

        // Collect emitted states
        final states = <CreateArticleState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.uploadImage(mockFile);

        // Wait for stream to propagate
        await Future<void>.delayed(Duration.zero);

        expect(states, expectedStates);

        await subscription.cancel();
      });

      test('emits [ImageUploading, Error] on failure', () async {
        const error = AppException(
          message: 'Upload failed',
          identifier: 'uploadArticleImage',
        );

        when(() => mockUploadImageUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const DataFailed(error));

        final states = <CreateArticleState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.uploadImage(mockFile);
        await Future<void>.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], const CreateArticleImageUploading());
        expect(states[1], isA<CreateArticleError>());
        expect(
          (states[1] as CreateArticleError).error.message,
          'Upload failed',
        );
        expect((states[1] as CreateArticleError).imageUrl, isNull);

        await subscription.cancel();
      });

      test('passes correct params to use case', () async {
        when(() => mockUploadImageUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer(
          (_) async => const DataSuccess('https://example.com/img.jpg'),
        );

        await cubit.uploadImage(mockFile);

        final captured = verify(
          () => mockUploadImageUseCase.call(params: captureAny(named: 'params')),
        ).captured;

        expect(captured.length, 1);
        expect(captured.first, isA<UploadArticleImageParams>());
        expect(
          (captured.first as UploadArticleImageParams).imageFile,
          mockFile,
        );
      });
    });

    group('submitArticle', () {
      const imageUrl = 'https://storage.example.com/image.jpg';
      final createdArticle = FirebaseArticleEntity(
        id: 'doc123',
        title: 'Test Title',
        description: 'Test Description',
        content: 'Test Content',
        author: 'Test Author',
        thumbnailUrl: imageUrl,
        createdAt: DateTime(2025, 1, 1),
      );

      test('emits [Submitting, Success] on success', () async {
        when(() => mockCreateArticleUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer((_) async => DataSuccess(createdArticle));

        final states = <CreateArticleState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.submitArticle(
          title: 'Test Title',
          description: 'Test Description',
          content: 'Test Content',
          author: 'Test Author',
          imageUrl: imageUrl,
        );
        await Future<void>.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], const CreateArticleSubmitting(imageUrl: imageUrl));
        expect(states[1], isA<CreateArticleSuccess>());
        expect((states[1] as CreateArticleSuccess).article.title, 'Test Title');

        await subscription.cancel();
      });

      test('emits [Submitting, Error] on failure, preserves imageUrl',
          () async {
        const error = AppException(
          message: 'Firestore write failed',
          identifier: 'createArticle',
        );

        when(() => mockCreateArticleUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const DataFailed(error));

        final states = <CreateArticleState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.submitArticle(
          title: 'Test Title',
          description: 'Test Description',
          content: 'Test Content',
          author: 'Test Author',
          imageUrl: imageUrl,
        );
        await Future<void>.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], const CreateArticleSubmitting(imageUrl: imageUrl));
        expect(states[1], isA<CreateArticleError>());
        expect((states[1] as CreateArticleError).imageUrl, imageUrl);
        expect(
          (states[1] as CreateArticleError).error.message,
          'Firestore write failed',
        );

        await subscription.cancel();
      });

      test('passes correct params to use case', () async {
        when(() => mockCreateArticleUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer((_) async => DataSuccess(createdArticle));

        await cubit.submitArticle(
          title: 'Test Title',
          description: 'Test Description',
          content: 'Test Content',
          author: 'Test Author',
          imageUrl: imageUrl,
        );

        final captured = verify(
          () => mockCreateArticleUseCase.call(
            params: captureAny(named: 'params'),
          ),
        ).captured;

        expect(captured.length, 1);
        final params = captured.first as CreateArticleParams;
        expect(params.title, 'Test Title');
        expect(params.description, 'Test Description');
        expect(params.content, 'Test Content');
        expect(params.author, 'Test Author');
        expect(params.thumbnailUrl, imageUrl);
      });
    });

    group('updateArticle', () {
      const imageUrl = 'https://storage.example.com/image.jpg';
      final updatedArticle = FirebaseArticleEntity(
        id: 'doc-123',
        title: 'Updated Title',
        description: 'Updated Description',
        content: 'Updated Content',
        author: 'Author',
        thumbnailUrl: imageUrl,
        category: 'technology',
        createdAt: DateTime(2026, 1, 1),
      );

      test('emits [Submitting, Success] on success', () async {
        when(() => mockUpdateArticleUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer((_) async => DataSuccess(updatedArticle));

        final states = <CreateArticleState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.updateArticle(
          id: 'doc-123',
          title: 'Updated Title',
          description: 'Updated Description',
          content: 'Updated Content',
          author: 'Author',
          imageUrl: imageUrl,
          category: 'technology',
          createdAt: DateTime(2026, 1, 1),
        );
        await Future<void>.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], const CreateArticleSubmitting(imageUrl: imageUrl));
        expect(states[1], isA<CreateArticleSuccess>());
        expect(
            (states[1] as CreateArticleSuccess).article.title, 'Updated Title');

        await subscription.cancel();
      });

      test('emits [Submitting, Error] on failure, preserves imageUrl',
          () async {
        const error = AppException(
          message: 'Update failed',
          identifier: 'updateArticle',
        );

        when(() => mockUpdateArticleUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer((_) async => const DataFailed(error));

        final states = <CreateArticleState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.updateArticle(
          id: 'doc-123',
          title: 'Title',
          description: 'Desc',
          content: 'Content',
          author: 'Author',
          imageUrl: imageUrl,
        );
        await Future<void>.delayed(Duration.zero);

        expect(states.length, 2);
        expect(states[0], const CreateArticleSubmitting(imageUrl: imageUrl));
        expect(states[1], isA<CreateArticleError>());
        expect((states[1] as CreateArticleError).imageUrl, imageUrl);
        expect((states[1] as CreateArticleError).error.message, 'Update failed');

        await subscription.cancel();
      });

      test('does nothing when updateArticleUseCase is null', () async {
        final cubitWithoutUpdate = CreateArticleCubit(
          uploadImageUseCase: mockUploadImageUseCase,
          createArticleUseCase: mockCreateArticleUseCase,
          // no updateArticleUseCase
        );

        final states = <CreateArticleState>[];
        final subscription = cubitWithoutUpdate.stream.listen(states.add);

        await cubitWithoutUpdate.updateArticle(
          id: 'doc-123',
          title: 'Title',
          description: 'Desc',
          content: 'Content',
          author: 'Author',
          imageUrl: imageUrl,
        );
        await Future<void>.delayed(Duration.zero);

        expect(states, isEmpty);
        verifyNever(() => mockUpdateArticleUseCase.call(
              params: any(named: 'params'),
            ));

        await subscription.cancel();
        cubitWithoutUpdate.close();
      });
    });

    group('reset', () {
      test('emits CreateArticleInitial', () async {
        // First put cubit in a non-initial state
        when(() => mockUploadImageUseCase.call(
              params: any(named: 'params'),
            )).thenAnswer(
          (_) async => const DataSuccess('https://example.com/img.jpg'),
        );
        await cubit.uploadImage(mockFile);

        final states = <CreateArticleState>[];
        final subscription = cubit.stream.listen(states.add);

        cubit.reset();
        await Future<void>.delayed(Duration.zero);

        expect(states.last, const CreateArticleInitial());

        await subscription.cancel();
      });
    });

    group('state equality', () {
      test('CreateArticleImageUploaded with same URL are equal', () {
        const state1 =
            CreateArticleImageUploaded(imageUrl: 'https://example.com/a.jpg');
        const state2 =
            CreateArticleImageUploaded(imageUrl: 'https://example.com/a.jpg');
        expect(state1, state2);
      });

      test('CreateArticleImageUploaded with different URLs are not equal', () {
        const state1 =
            CreateArticleImageUploaded(imageUrl: 'https://example.com/a.jpg');
        const state2 =
            CreateArticleImageUploaded(imageUrl: 'https://example.com/b.jpg');
        expect(state1, isNot(state2));
      });

      test('CreateArticleError preserves imageUrl for retry', () {
        const state = CreateArticleError(
          error: AppException(message: 'fail'),
          imageUrl: 'https://example.com/img.jpg',
        );
        expect(state.imageUrl, 'https://example.com/img.jpg');
      });
    });
  });
}
