import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/router/app_route.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Glance'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (BuildContext context, NewsState state) {
          if (state is LoadedNewsState) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int idx) {
                return const Divider();
              },
              // itemCount: _getNewsStories().length,
              itemCount: state.news.length,
              itemBuilder: (BuildContext context, int idx) {
                final NewsArticle article = state.news[idx];
                return ListTile(
                  key: Key('$idx ${article.hashCode}'),
                  title: Text(article.title),
                  subtitle: Text(article.description),
                  onTap: () async {
                    // if (article.description.isEmpty &&
                    //     article.articleText.isEmpty) {
                    //   final Uri url = Uri.parse(article.urlSource);
                    //   if (!await launchUrl(url)) {
                    //     throw PlatformException(
                    //       code: 'UNABLE_TO_LAUNCH_URL',
                    //       message: 'Could not launch ${article.urlSource}',
                    //     );
                    //   }
                    // } else {
                    // When the user taps the button,
                    // navigate to a named route and
                    // provide the arguments as an optional
                    // parameter.
                    Navigator.pushNamed(
                      context,
                      AppRoute.article.path,
                      arguments: article,
                    );
                    // }
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
