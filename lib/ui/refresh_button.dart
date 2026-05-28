import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/res/constants.dart' as constants;
import 'package:news_glance/res/storage_keys.dart' as storage_keys;
import 'package:shared_preferences/shared_preferences.dart';

class RefreshButton extends StatefulWidget {
  const RefreshButton({super.key});

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  late Future<int?> _lastFetchFuture;

  @override
  void initState() {
    super.initState();
    _lastFetchFuture = SharedPreferences.getInstance().then(
      (SharedPreferences p) => p.getInt(storage_keys.newsLastFetchAt),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _lastFetchFuture,
      builder: (BuildContext context, AsyncSnapshot<int?> snap) {
        // Only show button when future has completed successfully
        if (snap.connectionState != ConnectionState.done ||
            (!snap.hasData && snap.data == null)) {
          return const SizedBox.shrink();
        }

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
