import 'package:flutter/material.dart';

class AddCounterPage extends StatelessWidget {
  const AddCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add counter'),
      ),
      body: const Center(
        child: Text('add counter page'),
      ),
    );
  }
}
