import 'dart:io';
import 'package:path/path.dart' as p;

/// Create a `build` dir at file location
/// Accepts a `File`
/// Returns the `Directory` created
Directory createBuild(File f) {
  if (!f.existsSync()) {
    throw Exception('${f.absolute.path} does not exist');
  }

  Directory d = Directory(p.join(f.absolute.parent.path, 'build'));
  if (d.existsSync()) {
    d.deleteSync(recursive: true);
  }
  d.createSync(recursive: true);
  return d.absolute;
}

/// Get symtab file
/// Returns a `File`
File getSymtab(File fpath) {
  File f = File(p.join(fpath.absolute.parent.path, 'build', 'symtab.tmp'));
  if (!f.existsSync()) {
    f.createSync();
  }
  return f;
}

/// Get optab file
/// Returns a `File`
File getOptab(File fpath) {
  File f = File(p.join(fpath.absolute.parent.path, 'build', 'optab.bin'));
  if (!f.existsSync()) {
    f.createSync();
  }
  return f;
}

/// Get intermediate file
/// Returns a `File`
File getIntermediate(File fpath) {
  File f =
      File(p.join(fpath.absolute.parent.path, 'build', 'intermediate.tmp'));
  if (!f.existsSync()) {
    f.createSync();
  }
  return f;
}

/// Get output file
/// Returns a `File`
File getOut(File fpath) {
  File f = File(p.join(fpath.absolute.parent.path, 'build', 'output.bin'));
  if (!f.existsSync()) {
    f.createSync();
  }
  return f;
}

/// Get length file
/// Returns a `File`
File getLength(File fpath) {
  File f = File(p.join(fpath.absolute.parent.path, 'build', 'length'));
  if (!f.existsSync()) {
    f.createSync();
  }
  return f;
}
