import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/screens/profile_screen.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/cubit/create_article_cubit.dart';
import 'package:news_app_clean_architecture/features/create_article/presentation/screens/create_article_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/screens/home/daily_news.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/screens/saved_article/saved_article.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

/// Root shell with bottom navigation for the four primary destinations.
///
/// Uses an [IndexedStack] to preserve state across tab switches instead
/// of rebuilding each child on every navigation event.
class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  /// Each tab kept alive via IndexedStack.
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DailyNews(),
      const SavedArticles(),
      BlocProvider(
        create: (_) => sl<CreateArticleCubit>(),
        child: const CreateArticlePage(),
      ),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isLight ? Colors.black : Colors.white,
        unselectedItemColor: isLight ? Colors.grey : Colors.grey.shade600,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }
}
