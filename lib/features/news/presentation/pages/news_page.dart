import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/news_bloc.dart';
import '../widgets/article_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadInitialNews();
    _setupScrollController();
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
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial || state is NewsLoading && _currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NewsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: _loadInitialNews,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NewsLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.articles.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.articles.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final article = state.articles[index];
                return ArticleCard(
                  article: article,
                  onTap: () async {
                    final url = Uri.parse(article.url);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
