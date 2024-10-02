/// The optab that is used internally
Map<String, String> _optab = {
  "ADD": "18",
  "AND": "40",
  "COMP": "28",
  "DIV": "24",
  "J": "3C",
  "JEQ": "30",
  "JGT": "34",
  "JLT": "38",
  "JSUB": "48",
  "LDA": "00",
  "LDCH": "50",
  "LDL": "08",
  "LDX": "04",
  "MUL": "20",
  "OR": "44",
  "RD": "D8",
  "RSUB": "4C",
  "STA": "0C",
  "STCH": "54",
  "STL": "14",
  "STSW": "E8",
  "STX": "10",
  "SUB": "1C",
  "TD": "E0",
  "TIX": "2C",
  "WD": "DC",
};

/// Check if the mnemonic is valid.
/// Requires a String which is checked against the keys in optab.
/// Returns `true` if mnemonic is valid, otherwise returns `false`.
bool checkIsValid(String mnemonic) {
  for (var element in _optab.keys) {
    if (mnemonic == element) {
      return true;
    }
  }
  return false;
}

/// Returns the opcode of the `mnemonic` (`String`) passed.
/// Throws an error if the mnemonic is invalid.
String getOpcode(String mnemonic) {
  if (checkIsValid(mnemonic)) {
    return _optab[mnemonic]!;
  }
  throw Exception('$mnemonic not found');
}
