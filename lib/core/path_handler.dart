import 'dart:io';

/// Create a `build` dor at file location
/// Accepts a `File`
/// Returns the `Directory` created
Directory createBuild(File f) {
  if (!f.existsSync()) {
    throw Exception('${f.absolute.path} does not exist');
  }

  Directory d = Directory('${f.absolute.parent.path}/build');
  if (d.existsSync()) {
    throw Exception('${d.absolute.path} exists.');
  }
  d.createSync(recursive: true);
  return d.absolute;
}
