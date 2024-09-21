import 'dart:io';

/// `PassOne` class includes the implementation of
/// pass 1 of the two pass algorithm.
/// In addition, `PassOne` has methods to ensure fail
/// gracefully on absence of optab and srcFile in system.
/// This class is platform independent.
class PassOne {
  /// optab: The `File` that holds the opcode table.
  /// optab must have content as: `<opcode> <operand>`.
  final File optab;

  /// srcFile: The `File` that holds the assembly source code.
  final File srcFile;

  /// interFile: The `File` that holds the intermediate file.
  /// This file is generated at `path` provided if not already existing.
  final File interFile;

  /// symtab: The `File` that holds the symbol table.
  /// This file is generated at `path` provided if not already existing.
  /// Generates file in format: `<label> <address>`.
  final File symtab;

  /// len: The `File` that holds the program length.
  /// This file is generated at `path` provided if not already existing.
  final File len;

  PassOne(this.optab, this.srcFile, this.interFile, this.symtab, this.len) {
    if (!optab.existsSync()) {
      throw Exception('${optab.absolute.path} does not exist');
    } else if (!srcFile.existsSync()) {
      throw Exception('${srcFile.absolute.path} does not exist');
    }

    if (!interFile.existsSync()) {
      interFile.createSync(recursive: true);
    }
    if (!symtab.existsSync()) {
      symtab.createSync(recursive: true);
    }
    if (!len.existsSync()) {
      len.createSync(recursive: true);
    }
  }

  /// `run()` method runs the algorithm against `srcFile` and `optab`.
  /// It produces two files at `interFile` and `symtab`.
  /// The `run()` method returns the error code.
  /// Error codes are mapped as:
  /// ```
  /// | Error code | Error            |
  /// |------------|------------------|
  /// | 0          | No error         |
  /// | 1          | Duplicate symbol |
  /// | 2          | Invalid opcode   |
  /// ```
  /// In case of an error, error code is returned immediately and the output
  /// files will be invalid.
  int run() {
    int errCode = 0;
    // Dart lint exception for the name LOCCTR
    // ignore: non_constant_identifier_names
    int LOCCTR = 0, start = 0;

    List<String> inp = srcFile.readAsLinesSync();

    // Read the file line by line
    for (int x = 0; x < inp.length; x++) {
      List<String> line = inp[x].split('\t');
      if (x == 0) {
        if (line[1] == 'START') {
          start = int.tryParse(line[2]) ?? -1;
          if (start == -1) {
            throw Exception(
                'Expected integer after START @ ${srcFile.path}, line ${x + 1}');
          }
          LOCCTR = start;
          interFile.writeAsStringSync('${inp[x]}\n');
        } else {
          LOCCTR = 0;
        }
      }

      while (line[1] != 'END') {
        // ; starts comment
        if (!inp[x].startsWith(';')) {
          // Symbol search
          if (line[0] != '-') {
            List<String> sym = symtab.readAsLinesSync();
            int found = 0;
            for (int y = 0; y < sym.length; y++) {
              if (sym[y].split('\t').contains(line[0])) {
                errCode = 1;
                found = 1;
                return errCode;
              }
            }
            if (found == 0) {
              symtab.writeAsStringSync(
                  '${line[0]}\t${LOCCTR.toRadixString(16)}\n');
            }
          }

          // Optab search
          int found = 0;
          List<String> op = optab.readAsLinesSync();
          for (int y = 0; y < op.length; y++) {
            if (op.contains(line[1])) {
              found = 1;
              break;
            }
          }
          if (found == 0) {
            errCode = 2;
            return errCode;
          } else {
            LOCCTR += 3;
            switch (line[1]) {
              case 'WORD':
                LOCCTR += 3;
                break;
              case 'RESW':
                LOCCTR += (3 * (int.tryParse(line[2]) ?? 1));
                break;
              case 'RESB':
                LOCCTR += int.tryParse(line[2]) ?? 3;
                break;
              case 'BYTE':
                LOCCTR += line[2].length;
                break;
            }
          }
        }
        interFile
            .writeAsStringSync('${LOCCTR.toRadixString(16)}\t${line[0]}\n');
      }
      interFile.writeAsStringSync('${LOCCTR.toRadixString(16)}\t${line[0]}\n');
    }

    len.writeAsStringSync((LOCCTR - start).toRadixString(16));
    return errCode;
  }
}
