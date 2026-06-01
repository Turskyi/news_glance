import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/about/about_footer.dart';
import 'package:news_glance/ui/about/about_header.dart';
import 'package:news_glance/ui/about/about_info_card.dart';
import 'package:news_glance/ui/about/example_briefing_card.dart';
import 'package:news_glance/ui/about/fade_in_up.dart';
import 'package:news_glance/ui/about/how_it_works_section.dart';
import 'package:news_glance/ui/about/key_features_section.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();
  String _version = '...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    final String appName = l10n?.appName ?? constants.appName;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: kIsWeb
            ? IconButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoute.home.path,
                  (Route<dynamic> route) => false,
                ),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    'assets/images/news_glance_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : null,
        title: Text(
          l10n?.aboutApp(appName) ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.primary,
              colorScheme.primaryContainer,
              colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: <Widget>[
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: AboutHeader(
                            appName: appName,
                            version: _version,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: AboutInfoCard(
                            title: l10n?.whatIsNewsGlance ?? '',
                            content: l10n?.whatIsNewsGlanceContent ?? '',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: AboutInfoCard(
                            title: l10n?.whyItExists ?? '',
                            content: l10n?.whyItExistsContent ?? '',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const FadeInUp(
                          delay: Duration(milliseconds: 400),
                          child: HowItWorksSection(),
                        ),
                        const SizedBox(height: 16),
                        const FadeInUp(
                          delay: Duration(milliseconds: 500),
                          child: ExampleBriefingCard(),
                        ),
                        const SizedBox(height: 24),
                        const FadeInUp(
                          delay: Duration(milliseconds: 600),
                          child: KeyFeaturesSection(),
                        ),
                        const SizedBox(height: 24),
                        FadeInUp(
                          delay: const Duration(milliseconds: 700),
                          child: AboutInfoCard(
                            title: l10n?.transparency ?? '',
                            content: l10n?.transparencyContent ?? '',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          delay: const Duration(milliseconds: 800),
                          child: AboutInfoCard(
                            title: l10n?.privacy ?? '',
                            content: l10n?.privacyContent ?? '',
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 900),
                          child: AboutFooter(
                            appName: appName,
                            version: _version,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = packageInfo.version;
      });
    }
  }
}
