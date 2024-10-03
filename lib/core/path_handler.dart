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
  return File(p.join(fpath.absolute.parent.path, 'build', 'symtab.tmp'));
}

/// Get optab file
/// Returns a `File`
File getOptab(File fpath) {
  return File(p.join(fpath.absolute.parent.path, 'build', 'optab.bin'));
}

/// Get intermediate file
/// Returns a `File`
File getIntermediate(File fpath) {
  return File(p.join(fpath.absolute.parent.path, 'build', 'intermediate.tmp'));
}

/// Get output file
/// Returns a `File`
File getOut(File fpath) {
  return File(p.join(fpath.absolute.parent.path, 'build', 'output.bin'));
}

/// Get length file
/// Returns a `File`
File getLength(File fpath) {
  return File(p.join(fpath.absolute.parent.path, 'build', 'length'));
}
