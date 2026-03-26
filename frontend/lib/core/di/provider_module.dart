import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/core/services/connectivity_service.dart';
import 'package:news_app_clean_architecture/core/services/draft_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';

/// Registers shared provider instances (Firebase, Dio, Connectivity, etc.).
///
/// Isolates third-party SDK imports from the main DI container so that
/// feature modules and the container itself depend only on abstractions.
Future<void> registerProviderModule(GetIt sl) async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Firebase
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);

  // Connectivity
  sl.registerSingleton<ConnectivityServiceBase>(ConnectivityService());

  // Draft Service
  sl.registerSingleton<DraftService>(DraftService());
}
