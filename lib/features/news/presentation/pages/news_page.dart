import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/premium/premium_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../premium/presentation/pages/premium_page.dart';
import '../bloc/news_bloc.dart';
import '../widgets/modern_article_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _scrollController = ScrollController();
  final _premiumManager = sl<PremiumManager>();
  final _firebaseService = sl<FirebaseService>();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadInitialNews();
    _setupScrollController();
    _loadAds();
  }

  Future<void> _loadAds() async {
    if (!_premiumManager.isPremium) {
      await _premiumManager.loadInterstitialAd();
    }
  }

  void _loadInitialNews() {
    context.read<NewsBloc>().add(
          const GetTopHeadlinesEvent(
            country: 'us',
            category: 'technology',
          ),
        );
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _loadMoreNews();
      }
    });
  }

  void _loadMoreNews() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });

      context.read<NewsBloc>().add(
            LoadMoreTopHeadlinesEvent(
              country: 'us',
              category: 'technology',
              page: _currentPage,
            ),
          );

      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PremiumPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _firebaseService.signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsInitial || state is NewsLoading && _currentPage == 1) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is NewsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(state.message),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: _loadInitialNews,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is NewsLoaded) {
                  if (state.articles.isEmpty) {
                    return const Center(
                      child: Text('No articles found'),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.articles.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.articles.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final article = state.articles[index];
                      return ModernArticleCard(
                        article: article,
                        onTap: () => launchUrl(Uri.parse(article.url)),
                        onBookmark: () async {
                          await _firebaseService.toggleBookmark(article.url);
                          if (!_premiumManager.isPremium) {
                            await _premiumManager.showInterstitialAd();
                          }
                        },
                        onSummarize: () async {
                          // TODO: Implement article summarization
                        },
                        isBookmarked: false,
                        isPremium: _premiumManager.isPremium,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          if (!_premiumManager.isPremium)
            Container(
              height: 50,
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: _premiumManager.getBannerAd() != null
                    ? AdWidget(ad: _premiumManager.getBannerAd()!)
                    : const Text('Advertisement'),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
