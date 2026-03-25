import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/config/theme/theme_cubit.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_state.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/screens/login_screen.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/shared/widgets/main_navigation.dart';
import 'package:news_app_clean_architecture/shared/widgets/splash_screen.dart';
import 'config/theme/app_themes.dart';
import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() => _showSplash = false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesBloc>(
          create: (context) => sl()..add(const GetArticles()),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit()..init(),
        ),
        BlocProvider<AuthCubit>.value(
          value: sl<AuthCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: themeMode,
            onGenerateRoute: AppRoutes.onGenerateRoutes,
            home: _showSplash
                ? SplashScreen(onInitialized: _onSplashComplete)
                : const _AuthGate(),
          );
        },
      ),
    );
  }
}

/// Switches between [LoginScreen] and [MainNavigation] based on auth state.
///
/// Listens to [AuthCubit] and displays the appropriate screen. This keeps
/// the auth gate at the root level, ensuring unauthenticated users cannot
/// access the main app.
class _AuthGate extends StatelessWidget {
  const _AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainNavigation();
        }
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // AuthUnauthenticated or AuthError -> show login
        return const LoginScreen();
      },
    );
  }
}
