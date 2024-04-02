import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oyics/router.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OYICS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class LocalDataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<String?> readLocalData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File> writeLocalData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.storage});

  final LocalDataStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _data;

  @override
  void initState() {
    super.initState();
    widget.storage.readLocalData().then((value) {
      setState(() {
        _data = value;
      });
    });
  }

  Future<File>? _updateStorage() {
    setState(() {

    });
    if (_data == null) {
      print('data is null on _updateStorage!');
      return null;
    }
    return widget.storage.writeLocalData(_data!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('OYICS'),
      ),
      body: Center(
        child: Text(_data ?? 'data is null'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add_counter'),
        tooltip: 'Add counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
