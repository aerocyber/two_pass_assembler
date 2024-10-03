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

  /// Program length
  final File len;

  Map<String, String> symbols = {};

  PassOne({
    required this.src,
    required this.inter,
    required this.symtab,
    required this.len,
  });

  /// Run the algorithm and return error codes
  /// errorCode | Reference
  /// 0 | No error
  /// 1 | Duplicate Symbol
  /// 2 | Invalid opcode
  int runAlgorithm() {

    List<String> contents = src.readAsLinesSync();
    int locctr = 0, start = 0;

    for (int i = 0; i < contents.length; i++) {
      List<String> line = PassOne.formatLine(contents[i]);

      // START
      if (i == 0 && line[1] == 'START') {
        start = fromHex(line[2]);
        locctr = start;
        inter.writeAsStringSync(
            '${PassOne.toHex(locctr)} ${line[0]} ${line[1]} ${line[2]}\n');
        continue;
      }

      // Until END
      while (line[1] != 'END') {
        // IF COMMENT LINE
        if (line[0].startsWith(';')) {
          inter.writeAsStringSync(contents[i]);
          continue;
        }

        // If symbol
        if (symbolInSymtab(line[0]) && line[0] != '-') {
          return 1;
        } else {
          symbols.addAll({line[i]: PassOne.toHex(locctr)});
        }

        // optab search
        if (checkIsValid(line[1])) {
          locctr += 3;
        } else if (line[1] == 'WORD') {
          locctr += 3;
        } else if (line[1] == 'RESW') {
          locctr += 3 * int.parse(line[2], radix: 16);
        } else if (line[1] == 'RESB') {
          locctr += int.parse(line[2], radix: 16);
        } else if (line[1] == 'BYTE') {
          locctr += line[2].length;
        } else {
          return 2;
        }

        inter.writeAsStringSync(
            '${PassOne.toHex(locctr)} ${line[0]} ${line[1]} ${line[2]}');
      }
      inter.writeAsStringSync(
          '${PassOne.toHex(locctr)} ${line[0]} ${line[1]} ${line[2]}');
    }
    writeSymtab();
    int length = locctr - start;
    len.writeAsStringSync(length.toRadixString(16));
    return 0;
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
  static List<String> formatLine(String inp) {
    List<String> out = [];
    for (String word in inp.split(' ')) {
      word.trim();
      if (word != '' || word.isNotEmpty) {
        out.add(word);
      }
    }
    return out;
  }

  /// Check if symbol is in symtab.
  /// Returns `true` if symbol is in symtab else return `false`
  bool symbolInSymtab(String symbol) {
    for (int i = 0; i < symbols.keys.length; i++) {
      if (symbol == (symbols.keys as List)[i]) {
        return true;
      }
    }
    return false;
  }

  /// Write symtab to file
  void writeSymtab() {
    String key, value;
    for (int i = 0; i < symbols.keys.length; i++) {
      key = symbols.keys.toList()[i];
      value = symbols[key]!;
      symtab.writeAsStringSync('$key $value\n');
    }
  }
}
