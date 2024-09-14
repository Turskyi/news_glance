import 'package:flutter/material.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/ui/clickable_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Contact Us',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
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
