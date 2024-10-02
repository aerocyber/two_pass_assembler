import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int _counter = 0;
  TextEditingController cntr1 = TextEditingController();
  TextEditingController cntr2 = TextEditingController();
  final __key = GlobalKey<FormState>();
  late String path1, path2;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
      body: Center(
        child: Form(
          key: __key,
          child: Padding(
            padding: const EdgeInsets.all(150.0),
            child: Column(
              children: [
                TextFormField(
                  maxLength: 1000,
                  controller: cntr1,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    prefixIcon: const Icon(Icons.file_open),
                    hintText: 'Enter the path to the input file',
                    labelText: 'Path to input file *',
                    suffixIcon: cntr1.text.isEmpty
                        ? InkWell(
                            onTap: () =>
                                {}, // TODO: Method to get dir by opening it
                            child: const Icon(Icons.manage_search),
                          )
                        : null,
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
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLength: 1000,
                  controller: cntr2,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    prefixIcon: const Icon(Icons.file_open),
                    hintText: 'Enter the path to the optab file',
                    labelText: 'Path to optab file *',
                    suffixIcon: cntr2.text.isEmpty
                        ? InkWell(
                            onTap: () =>
                                {}, // TODO: Method to get dir by opening it
                            child: const Icon(Icons.manage_search),
                          )
                        : null,
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
                    path2 = value!;
                  },
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
                          // TODO: Build event
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
                        cntr2.text = '';
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
