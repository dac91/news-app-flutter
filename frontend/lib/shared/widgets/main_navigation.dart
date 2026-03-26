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

  /// Key for the SavedArticles widget so we can call refresh() on it.
  final _savedArticlesKey = GlobalKey<SavedArticlesState>();

  /// Each tab kept alive via IndexedStack.
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DailyNews(),
      SavedArticles(key: _savedArticlesKey),
      BlocProvider(
        create: (_) => sl<CreateArticleCubit>(),
        child: const CreateArticlePage(showBackButton: false),
      ),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'SAVED',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'CREATE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    // Re-fetch saved articles when the Saved tab is selected so bookmarks
    // made from article detail pages are immediately visible.
    if (index == 1) {
      _savedArticlesKey.currentState?.refresh();
    }
  }
}
