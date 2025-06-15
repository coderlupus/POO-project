import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final String? name;
  final String? status;

  const FilterPage({super.key, this.name, this.status});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
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
        title: Text('Filtrar Personagens'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(labelText: 'Status'),
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
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Aplicar filtro'),
            )
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this.isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
