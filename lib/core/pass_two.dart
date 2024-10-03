import 'dart:convert';
import 'dart:io';
import 'package:two_pass_assembler/core/optab.dart';
import 'package:two_pass_assembler/core/pass_one.dart';

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

  /// Output file
  /// Created if not existing
  final File outFile;

  /// Length of the program
  final File len;

  /// Symbols read from symtab
  Map<String, String> symbols = {};

  PassTwo(
      {required this.inter,
      required this.symtab,
      required this.outFile,
      required this.len});

  /// `run()` method runs the pass 2 algorithm.
  /// It produces output files at `outFile`.
  /// The `run()` method returns the error code.
  /// Error codes are mapped as:
  /// ```
  /// | Error code | Error            |
  /// |------------|------------------|
  /// | 0          | No error         |
  /// | 1          | Undefined symbol |
  /// ```
  /// In case of an error, error code is returned immediately and the output
  /// files will be invalid.
  int run() {
    List<String> contents = inter.readAsLinesSync();
    List<String> line;
    int start = 0;

    String header = '';
    String textRec = 'T^';
    String opAddr = '';

    for (int i = 0; i < contents.length; i++) {
      line = PassTwo.formatLine(contents[i]);
      print(contents[i]);
      print(line[0]);
      print(line[1]);
      print(line[2]);
      print(line[3]);
      if (i == 0 && line[1] == 'START') {
        int l = int.parse(len.readAsStringSync());
        textRec += line[2];
        start = int.parse(line[2]);
        header = 'H^${l.toRadixString(16).padLeft(6)}';
        outFile.writeAsStringSync('$header\n');
      } else {
        textRec += '0000';
      }

      textRec += "^${int.parse(len.readAsStringSync())}^";

      // TEXT record
      // IF comment
      if (contents[i].startsWith(';')) {
        continue;
      }

      // IF opcode
      if (checkIsValid(line[2])) {
        // IF symbol
        if (line[2].isNotEmpty) {
          if (symbolInSymtab(line[2])) {
            opAddr = (symbols[line[2]]!).padLeft(4);
          } else {
            return 1;
          }
        } else {
          opAddr = 0.toRadixString(16).padLeft(4);
        }
        textRec += '${getOpcode(line[2])}$opAddr';
      } else if (line[2] == 'BYTE') {
        List<int> obj = line[3].substring(2, line[3].length).codeUnits;
        String s = String.fromCharCodes(obj);
        String objCode = utf8.encode(s).map((e) => e.toRadixString(16)).join();
        textRec += "${getOpcode(line[2])}$objCode";
      } else if (line[2] == 'WORD') {
        textRec +=
            "${getOpcode('WORD')}${int.parse(line[3]).toRadixString(16).padLeft(4)}";
      }
    }

    outFile.writeAsString(
        '$header\n$textRec\nE^${start.toRadixString(16).padLeft(4)}');
    return 0;
  }

  /// Read symtab file and add the content to the symbols variable
  void readSymtab() {
    List<String> contents = symtab.readAsLinesSync();
    List<String> line = [];
    for (int i = 0; i < contents.length; i++) {
      line = PassOne.formatLine(contents[i]);
      symbols.addAll({line[0]: line[1]});
    }
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
}
