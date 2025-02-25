part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;

  const NewsLoaded({required this.articles});

  @override
  List<Object> get props => [articles];
}

class NewsError extends NewsState {
  final String message;

  const NewsError({required this.message});

  @override
  List<Object> get props => [message];
}
