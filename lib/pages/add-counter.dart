import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oyics/main.dart';

class AddCounterPage extends StatefulWidget {
  const AddCounterPage({super.key});

  @override
  State<AddCounterPage> createState() => _AddCounterPageState();
}

class _AddCounterPageState extends State<AddCounterPage> {

  Map<String, String?> formData = {};
  final _addCounterFormKey = GlobalKey<FormState>();
  final TextEditingController counterTitleController = TextEditingController();
  final TextEditingController daysToCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add counter'),
      ),
      body: Form(
        key: _addCounterFormKey,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: counterTitleController,
                decoration: const InputDecoration(
                  label: Text('Title'),
                  prefixIcon: Icon(Icons.title),
                ),
                autofocus: true,
                minLines: 1,
                maxLines: 3,
                onSaved: (String? value) {
                  formData['counterTitle'] = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: daysToCountController,
                decoration: const InputDecoration(
                  label: Text('Days to count'),
                  prefixIcon: Icon(Icons.access_time_outlined),
                ),
                keyboardType: TextInputType.number,
                onSaved: (String? value) {
                  formData['daysToCount'] = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of days';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () async {
                  if (_addCounterFormKey.currentState!.validate()) {
                    _addCounterFormKey.currentState!.save();
                    context.pop(formData);
                  }
                },
                child: const Text('add new gem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
