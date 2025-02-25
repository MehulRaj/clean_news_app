// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      preferredCategories: (json['preferredCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      preferredSources: (json['preferredSources'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bookmarkedArticles: (json['bookmarkedArticles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isPremium: json['isPremium'] as bool,
      categoryWeights: (json['categoryWeights'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'preferredCategories': instance.preferredCategories,
      'preferredSources': instance.preferredSources,
      'bookmarkedArticles': instance.bookmarkedArticles,
      'isPremium': instance.isPremium,
      'categoryWeights': instance.categoryWeights,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
