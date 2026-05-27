import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/res/storage_keys.dart' as storage_keys;
import 'package:shared_preferences/shared_preferences.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: SharedPreferences.getInstance().then((SharedPreferences p) {
        return p.getInt(storage_keys.newsLastFetchAt);
      }),
      builder: (BuildContext context, AsyncSnapshot<int?> snap) {
        final int? last = snap.data;
        final int now = DateTime.now().millisecondsSinceEpoch;
        final bool canRefresh =
            last == null ||
            (now - last) >= (constants.manualRefreshMinMinutes * 60 * 1000);
        if (canRefresh) {
          return TextButton.icon(
            onPressed: () => _handleRefresh(context),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Refresh', style: TextStyle(color: Colors.white)),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void _handleRefresh(BuildContext context) {
    try {
      context.read<NewsBloc>().add(const LoadNewsEvent());
    } catch (_) {}
  }
}
