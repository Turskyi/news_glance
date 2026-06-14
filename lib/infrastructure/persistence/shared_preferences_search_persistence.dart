import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_services/search_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: SearchPersistence)
class SharedPreferencesSearchPersistence implements SearchPersistence {
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 10;

  @override
  Future<void> saveRecentSearch(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> searches = await getRecentSearches();

    // Remove if already exists to move it to the top
    searches.remove(query);
    searches.insert(0, query);

    if (searches.length > _maxRecentSearches) {
      searches.removeLast();
    }

    await prefs.setStringList(_recentSearchesKey, searches);
  }

  @override
  Future<List<String>> getRecentSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchesKey) ?? <String>[];
  }

  @override
  Future<void> clearRecentSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
  }
}
