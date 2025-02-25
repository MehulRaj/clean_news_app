import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_preferences.g.dart';

@JsonSerializable()
class UserPreferences extends Equatable {
  final List<String> preferredCategories;
  final List<String> preferredSources;
  final List<String> bookmarkedArticles;
  final bool isPremium;
  final Map<String, double> categoryWeights;
  final DateTime lastUpdated;

  const UserPreferences({
    required this.preferredCategories,
    required this.preferredSources,
    required this.bookmarkedArticles,
    required this.isPremium,
    required this.categoryWeights,
    required this.lastUpdated,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    List<String>? preferredCategories,
    List<String>? preferredSources,
    List<String>? bookmarkedArticles,
    bool? isPremium,
    Map<String, double>? categoryWeights,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      preferredCategories: preferredCategories ?? this.preferredCategories,
      preferredSources: preferredSources ?? this.preferredSources,
      bookmarkedArticles: bookmarkedArticles ?? this.bookmarkedArticles,
      isPremium: isPremium ?? this.isPremium,
      categoryWeights: categoryWeights ?? this.categoryWeights,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        preferredCategories,
        preferredSources,
        bookmarkedArticles,
        isPremium,
        categoryWeights,
        lastUpdated,
      ];
}
