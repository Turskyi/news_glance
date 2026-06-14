import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Ensure .withOpacity() is not used in the codebase', () {
    final Directory libDir = Directory('lib');
    final List<FileSystemEntity> files = libDir.listSync(recursive: true);

    final List<String> filesWithWithOpacity = <String>[];

    for (final FileSystemEntity file in files) {
      if (file is File && file.path.endsWith('.dart')) {
        final String content = file.readAsStringSync();
        if (content.contains('.withOpacity(')) {
          filesWithWithOpacity.add(file.path);
        }
      }
    }

    expect(
      filesWithWithOpacity,
      isEmpty,
      reason:
          'The following files use the deprecated .withOpacity() method. '
          'Please use .withValues(alpha: ...) instead:\n'
          '${filesWithWithOpacity.join('\n')}',
    );
  });
}
