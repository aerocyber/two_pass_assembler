import 'dart:io';

/// `PassTwo` class includes the implementation of
/// pass 2 of the two pass algorithm.
/// In addition, `PassTwo` has methods to ensure fail
/// gracefully on absence of inter, optab and symtab in system.
/// This class is platform independent.
class PassTwo {
  /// Intermediate file (from pass1)
  final File inter;

  /// Symtab (from pass 1)
  final File symtab;

  /// Optab
  final File optab;

  /// Output file
  /// Created if not existing
  final File outFile;

  PassTwo(this.inter, this.symtab, this.outFile, this.optab) {
    if (!inter.existsSync()) {
      throw Exception(
          'Intermediate file is not found at ${inter.absolute.path}.');
    }
    if (!symtab.existsSync()) {
      throw Exception('Symtab file is not found at ${symtab.absolute.path}.');
    }
    if (!optab.existsSync()) {
      throw Exception('Optab file is not found at ${optab.absolute.path}.');
    }
  }

  /// `run()` method runs the pass 2 algorithm.
  /// It produces output files at `outFile`.
  /// The `run()` method returns the error code.
  /// Error codes are mapped as:
  // TODO: Correct the err codes
  /// ```
  /// | Error code | Error            |
  /// |------------|------------------|
  /// | 0          | No error         |
  /// | 1          | Duplicate symbol |
  /// | 2          | Invalid opcode   |
  /// ```
  /// In case of an error, error code is returned immediately and the output
  /// files will be invalid.
}
