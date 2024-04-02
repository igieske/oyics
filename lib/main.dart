import 'dart:convert';
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
      debugShowCheckedModeBanner: false,
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
  List<dynamic> _counters = [];

  @override
  void initState() {
    super.initState();
    widget.storage.readLocalData().then((value) {
      setState(() {
        _data = value;
        if (_data == null) {
          print('data is null on initState!');
          return;
        }
        Map<String, dynamic> decodedJSON;
        try {
          decodedJSON = json.decode(value!) as Map<String, dynamic>;
        } on FormatException catch (e) {
          print('! ошибка парсинга json: ${e.message}');
          print(_data);
          return;
        }
        _counters = decodedJSON['counters'];
      });
    });
  }

  Future<File?> _addCounterToStorage(Map<String, dynamic> counterData) async {
    final String data = _data ?? '{"counters": []}';
    Map<String, dynamic> decodedJSON;
    try {
      decodedJSON = json.decode(data) as Map<String, dynamic>;
    } on FormatException catch (e) {
      print('! ошибка парсинга json: ${e.message}');
      print(data);
      return null;
    }
    print(decodedJSON);
    print(decodedJSON['counters']);
    final List<dynamic> counters = decodedJSON['counters'];
    print('каунтеров пока: ${counters.length}');
    counters.add(counterData);
    print(counters);
    decodedJSON['counters'] = counters;
    print(decodedJSON);
    final String encodedJSON = json.encode(decodedJSON);
    widget.storage.writeLocalData(encodedJSON);
    setState(() {
      _data = encodedJSON;
      _counters = counters;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('OYICS'),
      ),
      body: _data == null
        ? const Center(child: Text('add your firs counter!'))
        : _counters.isEmpty
          ? const Center(child: Text('no counters'))
          : ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemCount: _counters.length,
            itemBuilder: (_, int index) {
              final Map<String, dynamic> counter = _counters[index];
              return Column(
                children: [
                  Text(counter['counterTitle'] ?? 'No title'),
                  Text(counter['daysToCount'] ?? 'Failed load days to count'),
                ],
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Map<String, dynamic>? addCounterReturn
            = await context.push('/add_counter');
          if (addCounterReturn != null) {
            _addCounterToStorage(addCounterReturn);
          }
        },
        tooltip: 'Add counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
