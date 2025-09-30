import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/theme/theme_provider.dart';
import 'package:news_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:news_app/features/auth/presentation/providers/auth_state.dart';
import 'package:news_app/features/auth/presentation/views/login_view.dart';
import 'package:news_app/features/auth/presentation/widgets/dialog_utils.dart';
import 'package:news_app/features/news/domain/entities/news_entity.dart';
import 'package:news_app/features/news/presentation/providers/news_notifier.dart';
import 'package:news_app/features/news/presentation/providers/news_provider.dart';
import 'package:news_app/features/news/presentation/providers/news_state.dart';
import 'package:news_app/features/news/presentation/view/article_detail_view.dart';
import 'package:news_app/features/news/presentation/widgets/news_list.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsProvider.notifier).fetchNews();
      _checkAuthStatus();
    });
  }

  void _checkAuthStatus() {
    final authState = ref.read(authNotifierProvider);
    if (!authState.isAuthenticated) {
      _navigateToLogin();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final currentPage = ref.read(newsProvider).currentPage;
      ref.read(newsProvider.notifier).fetchNews(page: currentPage + 1);
    }
  }

  Future<void> _handleSignOut() async {
    final result = await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
    );

    if (result == true) {
      setState(() {
        _isLoggingOut = true;
      });

      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final state = ref.watch(newsProvider);
    final authState = ref.watch(authNotifierProvider);
    final notifier = ref.read(newsProvider.notifier);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (!next.isAuthenticated && !next.isLoading) {
        setState(() {
          _isLoggingOut = false;
        });
        _navigateToLogin();
      }

      if (next.error != null && !next.isLoading && _isLoggingOut) {
        setState(() {
          _isLoggingOut = false;
        });
        DialogUtils.showErrorDialog(
          context: context,
          title: 'Logout Failed',
          message: next.error!,
          onOk: () {
            ref.read(authNotifierProvider.notifier).clearError();
          },
        );
      }
    });

    List<News> filteredNews = state.news;
    if (_searchController.text.isNotEmpty) {
      filteredNews = state.news.where((news) {
        final title = news.title.toLowerCase();
        final content = news.content?.toLowerCase() ?? '';
        final searchTerm = _searchController.text.toLowerCase();
        return title.contains(searchTerm) || content.contains(searchTerm);
      }).toList();
    }

    if (_isLoggingOut) {
      return Scaffold(
        body: Stack(
          children: [
            _buildHomeContent(theme, state, authState, notifier, filteredNews),
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Signing out...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _buildHomeContent(theme, state, authState, notifier, filteredNews);
  }

  Widget _buildHomeContent(
    ThemeData theme,
    NewsState state,
    AuthState authState,
    NewsNotifier notifier,
    List<News> filteredNews,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            tooltip: 'Toggle theme',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                _handleSignOut();
              } else if (value == 'profile') {
                _showUserProfile();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authState.user?.displayName ?? 'User',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          authState.user?.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 20,
                      color: _isLoggingOut ? Colors.grey : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        color: _isLoggingOut ? Colors.grey : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (authState.user?.displayName != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text(
                'Welcome back, ${authState.user?.displayName}!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => notifier.refreshNews(),
              child: NewsList(
                scrollController: _scrollController,
                news: filteredNews,
                isLoading: state.isLoading,
                onTap: (news) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailView(news: news),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserProfile() {
    final authState = ref.read(authNotifierProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileItem(
              'Name',
              authState.user?.displayName ?? 'Not provided',
            ),
            const SizedBox(height: 12),
            _buildProfileItem('Email', authState.user?.email ?? 'Not provided'),
            const SizedBox(height: 12),
            _buildProfileItem('User ID', authState.user?.id ?? 'Not provided'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }
}
