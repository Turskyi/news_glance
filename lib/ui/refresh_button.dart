import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/blocs/news_bloc.dart';
import 'package:news_glance/domain_services/briefing_persistence.dart';
import 'package:news_glance/res/constants.dart' as constants;

class RefreshButton extends StatefulWidget {
  const RefreshButton({required this.persistence, super.key});

  final BriefingPersistence persistence;

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  late Future<DateTime?> _lastFetchFuture;
  StreamSubscription<NewsState>? _newsSub;

  @override
  void initState() {
    super.initState();
    _lastFetchFuture = widget.persistence.getLastFetchTime();

    // Subscribe to NewsBloc stream to refresh the cached future when news
    // are loaded so the button visibility updates immediately.
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      try {
        final NewsBloc bloc = context.read<NewsBloc>();
        _newsSub = bloc.stream.listen((NewsState _) async {
          // Re-read the last fetch time from persistence and trigger rebuild
          final Future<DateTime?> newFuture = widget.persistence
              .getLastFetchTime();
          setState(() {
            _lastFetchFuture = newFuture;
          });
        });
      } catch (e) {
        debugPrint('Exception in RefreshButton initState: $e');
        // If bloc is not available, ignore - still works initially
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateTime?>(
      future: _lastFetchFuture,
      builder: (BuildContext context, AsyncSnapshot<DateTime?> snap) {
        // Only show button when future has completed successfully
        if (snap.connectionState != ConnectionState.done ||
            (snap.data == null && !snap.hasData)) {
          return const SizedBox.shrink();
        }

        final DateTime? last = snap.data;
        final DateTime now = DateTime.now();
        final bool canRefresh =
            last == null ||
            now.difference(last).inMinutes >= constants.manualRefreshMinMinutes;
        if (canRefresh) {
          return IconButton(
            onPressed: () => _handleRefresh(context),
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  void dispose() {
    _newsSub?.cancel();
    super.dispose();
  }

  void _handleRefresh(BuildContext context) {
    try {
      context.read<NewsBloc>().add(const LoadNewsEvent());
    } catch (e) {
      debugPrint('Exception in RefreshButton _handleRefresh: $e');
    }
  }
}
