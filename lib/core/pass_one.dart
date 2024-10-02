import 'dart:io';
import 'package:two_pass_assembler/core/optab.dart';

/// Handle the pass 1 algorithm and related methods.
/// Requires the source assembly (`File`), intermediate (`File`) and
/// symtab (`File`).
/// Error thrown if symtab or intermediate files are present at destination.
/// Error also thrown if source assembly does not exist.
class PassOne {
  /// Source file
  final File src;

  /// Intermediate file
  final File inter;

  /// Symtab file
  final File symtab;

  Map<String, String> symbols = {};

  PassOne({
    required this.src,
    required this.inter,
    required this.symtab,
  });

  /// Run the algorithm and return error codes
  // TODO: error code docs
  void runAlgorithm() {
    // TODO: Pass 1 implementation

    List<String> contents = src.readAsLinesSync();
    int locctr = 0, start = 0;

    for (int i = 0; i < contents.length; i++) {
      List<String> line = formatLine(contents[i]);

      // START
      if (i == 0 && line[1] == 'START') {
        start = fromHex(line[2]);
        locctr = start;
        inter.writeAsStringSync(
            '${toHex(locctr)} ${line[0]} ${line[1]} ${line[2]}\n');
        continue;
      }

      // Until END
      while (line[1] != 'END') {
        // IF COMMENT LINE
        if (line[0].startsWith(';')) {
          inter.writeAsStringSync(contents[i]);
          continue;
        }
      }
    }
  }

  /// Static method to convert decimal to hex.
  /// Returns a `String`, accepts an `int`.
  static String toHex(int decimalCode) {
    return decimalCode.toRadixString(16);
  }

  /// Static method to convert hex to decimal.
  /// Returns an `int` and accepts a `String`.
  static int fromHex(String hexcode) {
    return int.parse(hexcode, radix: 16);
  }

  /// Convert a `String` to `List<String>` based on whitespace.
  /// The `List` returned consist of `String` which is not empty.
  List<String> formatLine(String inp) {
    List<String> out = [];
    for (String word in inp.split(' ')) {
      word.trim();
      if (word != '' || word.isNotEmpty) {
        out.add(word);
      }
    }
    return out;
  }

  bool symbolInSymtab(String symbol) {
    for (int i = 0; i < symbols.keys.length; i++) {}
  }
}
