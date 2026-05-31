import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/domain_models/app_locale.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/clickable_tile.dart';
import 'package:news_glance/ui/widget_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }
    return Drawer(
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
              l10n.menu,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
              ),
            ),
          ),
          const WidgetSettings(),
          const Divider(),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (BuildContext context, SettingsState state) {
              return ListTile(
                title: Text(l10n.language),
                trailing: Text(
                  state.locale.displayCode,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  final AppLocale newLocale = state.locale.isUkrainian
                      ? AppLocale.english
                      : AppLocale.ukrainian;

                  context.read<SettingsBloc>().add(SetLocaleEvent(newLocale));
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutApp(l10n.appName)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoute.about.path);
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              l10n.contactUs,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ClickableTile(
            title: 'Website: ${constants.website}',
            onTap: () => _launchUrl(constants.website),
          ),
          ClickableTile(
            title: 'Email: ${constants.email}',
            onTap: () => _launchEmail(constants.email),
          ),
          ClickableTile(
            title: 'Phone: ${constants.phone}',
            onTap: () => _launchPhone(constants.phone),
          ),
          ClickableTile(
            title: constants.address,
            onTap: () => _launchMap(constants.address),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }

  void _launchEmail(String email) async {
    await launchUrl(Uri.parse('mailto:$email'));
  }

  void _launchPhone(String phone) async {
    await launchUrl(Uri.parse('tel:$phone'));
  }

  void _launchMap(String address) async {
    String mapUrl = 'https://www.google.com/maps?q=$address';
    await launchUrl(Uri.parse(mapUrl));
  }
}
