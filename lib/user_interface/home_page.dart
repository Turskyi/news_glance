import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[Colors.blue, Colors.indigo, Colors.purple],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.blue, Colors.indigo, Colors.purple],
                  ),
                ),
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        Theme.of(context).textTheme.headlineLarge?.fontSize,
                  ),
                ),
              ),
              _buildClickableTile(
                context,
                'Website: https://news.turskyi.com',
                () => _launchUrl('https://news.turskyi.com'),
              ),
              _buildClickableTile(
                context,
                'Email: dmytro@turskyi.com',
                () => _launchEmail('dmytro@turskyi.com'),
              ),
              _buildClickableTile(
                context,
                'Phone: +1 (437) 985-2581',
                () => _launchPhone('+14379852581'),
              ),
              _buildClickableTile(
                context,
                'Address: 500 Sherbourne St.,\nUnit. 2701\nToronto\nOntario\nM4X1L1\nCanada.',
                () => _launchMap(),
              ),
            ],
          ),
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (BuildContext context, NewsState state) {
            if (state is LoadedNewsState) {
              TextStyle style = TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              );
              const double adjustment = 20.0;
              return Semantics(
                label: 'Home screen with the title on top, and the list of '
                    'headlines of article news titles below.',
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      expandedHeight: state is LoadedConclusionState &&
                              state.conclusion.trim().isNotEmpty
                          ? _calculateExpandedHeight(
                              conclusion: state.conclusion,
                              availableWidth: MediaQuery.sizeOf(context).width,
                              style: style,
                            )
                          : kToolbarHeight + adjustment,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 29,
                            right: 20,
                            bottom: state is LoadedConclusionState ? 20 : 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'News Glance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> animation,
                                ) =>
                                    FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                                child: (state is LoadedConclusionState &&
                                        state.conclusion.trim().isNotEmpty)
                                    ? Text(
                                        state.conclusion,
                                        key: ValueKey<String>(state.conclusion),
                                        maxLines: 11,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            style.copyWith(color: Colors.white),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final NewsArticle article = state.news[index];
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // Adjust the value as needed
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Colors.blue.shade100,
                                    Colors.purple.shade100,
                                  ],
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(
                                  left: 20,
                                  right: 8,
                                  top: 8,
                                  bottom: 8,
                                ),
                                title: Text(
                                  article.title,
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  article.description,
                                  style: TextStyle(color: Colors.blue[900]),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.blue[300],
                                  size: 20,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.article.path,
                                    arguments: article,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        childCount: state.news.length,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ListTile _buildClickableTile(
    BuildContext context,
    String title,
    Function onTap,
  ) =>
      ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.blue),
        ),
        onTap: () => onTap(),
      );

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw Exception('Could not launch: $url');
    }
  }

  void _launchEmail(String email) async {
    if (await canLaunchUrl(Uri.parse('mailto:$email'))) {
      await launchUrl(Uri.parse('mailto:$email'));
    } else {
      throw Exception('Could not launch email client');
    }
  }

  void _launchPhone(String phone) async {
    if (await canLaunchUrl(Uri.parse('tel:$phone'))) {
      await launchUrl(Uri.parse('tel:$phone'));
    } else {
      throw Exception('Could not launch phone');
    }
  }

  void _launchMap() async {
    const double latitude = 43.6656;
    const double longitude = -79.3807;
    String mapUrl = 'https://www.google.com/maps?q=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl));
    } else {
      throw Exception('Could not launch map');
    }
  }

  double _calculateExpandedHeight({
    required String conclusion,
    required double availableWidth,
    required TextStyle style,
  }) {
    const double defaultExpandedHeight = 137.0;
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: conclusion,
        style: style,
      ),
      maxLines: 100,
      textDirection: TextDirection.ltr,
    );

    // Use the actual available width for layout
    textPainter.layout(maxWidth: availableWidth);

    // Calculate the number of lines based on the actual available width
    int numberOfLines = (textPainter.size.height / style.fontSize!).ceil();
    double expandedHeight =
        defaultExpandedHeight + numberOfLines * style.fontSize!;

    return expandedHeight;
  }
}
