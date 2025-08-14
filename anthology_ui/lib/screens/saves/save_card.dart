import 'package:flutter/material.dart';

class SaveCard extends StatelessWidget {
  const SaveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Save Title'),
        subtitle: const Text('Save Description'),
        trailing: SizedBox(
          height: 400,
          width: 400,
          child: Placeholder(),
        ),
      ),
    );
  }
}
