import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_pass_assembler/core/pass_one.dart';
import 'package:two_pass_assembler/core/pass_two.dart';
import 'package:two_pass_assembler/core/path_handler.dart';

void main() {
  runApp(const TwoPassApp());
}

class TwoPassApp extends StatelessWidget {
  const TwoPassApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Two Pass Assembler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const TwoPassHome(),
    );
  }
}

class TwoPassHome extends StatefulWidget {
  const TwoPassHome({super.key});

  @override
  State<TwoPassHome> createState() => _TwoPassHomeState();
}

class _TwoPassHomeState extends State<TwoPassHome> {
  TextEditingController cntr1 = TextEditingController();
  TextEditingController cntr2 = TextEditingController();
  final __key = GlobalKey<FormState>();
  late String path1, path2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Two Pass Assembler'),
        elevation: 20.0,
        centerTitle: true,
        toolbarHeight: 75.0,
        shadowColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Form(
        key: __key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 1000,
                  child: TextFormField(
                    maxLength: 1000,
                    controller: cntr1,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      prefixIcon: Icon(Icons.file_open),
                      hintText: 'Enter the path to the input file',
                      labelText: 'Path to input file *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a path";
                      }
                      if (!(File(value).existsSync())) {
                        return "Path does not exist";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      path1 = value!;
                    },
                  ),
                ),
                if (cntr1.text.isEmpty)
                  IconButton(
                    onPressed: () async {
                      FilePickerResult? fres =
                          await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        dialogTitle: 'Select the source code',
                        lockParentWindow: true,
                      );

                      if (fres != null) {
                        cntr1.text = fres.files.single.path!;
                      }
                    },
                    icon: const Icon(
                      Icons.attach_file,
                      size: 30,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    alignment: Alignment.center,
                    elevation: WidgetStatePropertyAll(8.0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (__key.currentState!.validate()) {
                      try {
                        File f = File(cntr1.text);
                        createBuild(f);
                        File symtab = getSymtab(f);
                        File out = getOut(f);
                        File inter = getIntermediate(f);
                        File le = getLength(f);
                        // Pass 1
                        PassOne p1 = PassOne(
                          inter: inter,
                          len: le,
                          src: f,
                          symtab: symtab,
                        );
                        PassTwo p2 = PassTwo(
                          inter: inter,
                          len: le,
                          outFile: out,
                          symtab: symtab,
                        );
                        int p1res = p1.runAlgorithm();
                        if (p1res != 0) {
                          String err = '';
                          if (p1res == 1) {
                            err = 'Duplicate symbol';
                          } else {
                            err = 'Invalid Opcode';
                          }
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text(err),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          int p2res = p2.run();
                          if (p2res != 0) {
                            String err = '';
                            err = 'Undefined Symbol';
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(err),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Build Complete"),
                                    content: const Text(
                                        "Built successfully into the build/ subdirectory."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  )
                                ],
                              );
                            });
                      }
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.build),
                      Text("Build"),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    alignment: Alignment.center,
                    elevation: WidgetStatePropertyAll(8.0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    cntr1.text = '';
                    setState(() {});
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.clear),
                      Text("Clear fields"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showAboutDialog(
            context: context,
            applicationName: 'Two Pass Algorithm (Frontend)',
            applicationVersion: '1.0.0',
          );
        },
        child: const Icon(Icons.info),
      ),
    );
  }
}
