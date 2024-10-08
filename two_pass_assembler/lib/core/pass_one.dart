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
  /// 3 | Invalid BYTE format
  int runAlgorithm() {
    List<String> contents = src.readAsLinesSync();
    int locctr = 0, start = 0;

    List<String> tmp = [];
    String s;

    List<String> line = [];

    for (int i = 0; i < contents.length; i++) {
      line = PassOne.formatLine(contents[i]);
      // print(line);
      if (line.isEmpty) continue; // skip empty line

      if (line[1] == 'END') {
        break;
      }
      // START
      if (i == 0 && line[1] == 'START') {
        start = fromHex(line[2]);
        locctr = start - 3;
        tmp.add('${line[0]} ${line[1]} ${line[2]}\n');
        continue;
      }

      // IF COMMENT LINE
      if (line[0].startsWith(';')) {
        inter.writeAsStringSync(contents[i]);
        continue;
      }

      // optab search
      if (checkIsValid(line[1])) {
        locctr += 3;
      } else if (line[1] == 'WORD') {
        locctr += 3;
      } else if (line[1] == 'RESW') {
        locctr += 3 * int.parse(line[2], radix: 16);
      } else if (line[1] == 'RESB') {
        locctr += int.parse(line[2]);
      } else if (line[1] == 'BYTE') {
        if (line[2].startsWith("C'")) {
          locctr += line[2].length - 3;
        } else if (line[2].startsWith("X'")) {
          locctr += (line[2].length - 3) ~/ 2;
        } else {
          return 3;
        }
      } else if (!symbolInSymtab(line[1])) {
        return 2;
      }
      // If symbol
      if (line.length > 1 && symbolInSymtab(line[0]) && line[0] != '-') {
        return 1;
      } else {
        if (!checkIsValid(line[0]) && line[0] != '-') {
          s = line[0].split(' ')[0];

          symbols.addAll({s: PassOne.toHex(locctr)});
        }
      }

      tmp.add('${PassOne.toHex(locctr)} ${line[0]} ${line[1]} ${line[2]}\n');
    }

    tmp.add('${line[0]} ${line[1]} ${line[2]}\n');

    writeSymtab();
    int length = locctr - start;
    len.writeAsStringSync(length.toRadixString(16));
    String tmpStr = '';
    for (int i = 0; i < tmp.length; i++) {
      tmpStr += tmp[i];
    }

    inter.writeAsStringSync(tmpStr);
    return 0;
  }

  /// Static method to convert decimal to hex.
  /// Returns a `String`, accepts an `int`.
  static String toHex(int decimalCode) {
    return decimalCode.toRadixString(16).padLeft(4, '0');
  }

  /// Static method to convert hex to decimal.
  /// Returns an `int` and accepts a `String`.
  static int fromHex(String hexcode) {
    return int.parse(hexcode, radix: 16);
  }

  /// Convert a `String` to `List<String>` based on whitespace.
  /// The `List` returned consist of `String` which is not empty.
  static List<String> formatLine(String inp) {
    return inp.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
  }

  /// Check if symbol is in symtab.
  /// Returns `true` if symbol is in symtab else return `false`
  bool symbolInSymtab(String symbol) {
    return symbols.containsKey(symbol);
  }

  /// Write symtab to file
  void writeSymtab() {
    final writ = symbols.entries
        .map((entry) => '${entry.key} ${entry.value}')
        .join('\n');
    symtab.writeAsStringSync('$writ\n', mode: FileMode.write);
  }
}
