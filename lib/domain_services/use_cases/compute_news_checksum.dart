import 'package:injectable/injectable.dart';
import 'package:news_glance/domain_models/news_article.dart';

@injectable
class ComputeNewsChecksum {
  int call(List<NewsArticle> articles) {
    final String joined = articles
        .map(
          (NewsArticle a) => (a.urlSource.isNotEmpty ? a.urlSource : a.title),
        )
        .join('|');
    return joined.hashCode;
  }
}
