import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final String? name;
  final String? status;

  const FilterPage({super.key, this.name, this.status});

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  final _nameController = TextEditingController();
  String? _status;

  final List<String> statusOptions = ['alive', 'dead', 'unknown'];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? '';
    _status = widget.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrar Personagens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: [null, ...statusOptions].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status == null ? 'Qualquer' : status.capitalize()),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _status = val;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Aplicar Filtro'),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
