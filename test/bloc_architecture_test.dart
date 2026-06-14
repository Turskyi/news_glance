import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Ensure SharedPreferences is not directly used in any Bloc', () {
    final Directory libDir = Directory('lib');
    final List<FileSystemEntity> files = libDir.listSync(recursive: true);

    final List<String> violatingFiles = <String>[];

    for (final FileSystemEntity file in files) {
      if (file is! File || !file.path.endsWith('.dart')) continue;

      final String path = file.path;
      final String content = file.readAsStringSync();

      // Identify if it's a Bloc-related file
      final bool isBlocClass =
          content.contains('extends Bloc<') ||
          content.contains('extends Cubit<');
      final bool isPartOffBloc =
          content.contains("part of '") &&
          (path.endsWith('_event.dart') ||
              path.endsWith('_state.dart') ||
              path.contains('/blocs/'));
      final bool isBlocFile =
          path.endsWith('_bloc.dart') ||
          path.endsWith('_cubit.dart') ||
          path.contains('/blocs/');

      if (isBlocClass || isBlocFile || isPartOffBloc) {
        if (content.contains('SharedPreferences') ||
            content.contains(
              'package:shared_preferences/shared_preferences.dart',
            )) {
          violatingFiles.add(path);
        }
      }
    }

    expect(
      violatingFiles,
      isEmpty,
      reason:
          'The following Bloc files directly reference SharedPreferences. '
          'Please use a Persistence interface from the Domain layer instead:\n'
          '${violatingFiles.join('\n')}',
    );
  });
}
