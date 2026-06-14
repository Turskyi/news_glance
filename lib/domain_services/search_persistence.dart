abstract interface class SearchPersistence {
  Future<void> saveRecentSearch(String query);

  Future<List<String>> getRecentSearches();

  Future<void> clearRecentSearches();
}
