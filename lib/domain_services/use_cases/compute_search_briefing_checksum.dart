import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/news_article.dart';

@injectable
class ComputeSearchBriefingChecksum {
  int call({
    required String query,
    required String briefingType,
    required List<NewsArticle> articles,
  }) {
    final String articlesFingerprint = articles
        .map(
          (NewsArticle a) => (a.urlSource.isNotEmpty ? a.urlSource : a.title),
        )
        .join('|');
    // We include a "search" salt to prevent collisions with global briefing
    // hashes and include the query to ensure query-specific results.
    return Object.hash('search', query, briefingType, articlesFingerprint);
  }
}
