# two_pass_assembler

Two pass assembler implementation

## Getting Started

Build instruction:

Get the source:
```bash
git clone https://github.com/aerocyber/two_pass_assembler
cd two_pass_assembler/two_pass_assembler
```

Get dependency:
```bash
flutter pub get
```

Build for release
```bash
# Linux
flutter build linux --release --tree-shake-icons --no-obfuscate

# Windows
flutter build windows --release --tree-shake-icons --no-obfuscate
```

To build documentation, install `pandoc` and then from the same dir as above,

```bash
cd docs/
pandoc index.md -o Two-Pass-Assembler-manual.pdf
```

## Docs

[See docs](two_pass_assembler/docs/index.html)