import 'package:flutter/material.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class SnippetFormFields extends StatelessWidget {
  const SnippetFormFields({
    required this.titleController,
    required this.commandController,
    required this.descriptionController,
    required this.labelsController,
    required this.requiredValidator,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController commandController;
  final TextEditingController descriptionController;
  final TextEditingController labelsController;
  final FormFieldValidator<String> requiredValidator;

  @override
  Widget build(BuildContext context) {
    return SurfSection(
      child: Column(
        children: [
          TextFormField(
            key: const Key('snippet-title'),
            controller: titleController,
            validator: requiredValidator,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('snippet-command'),
            controller: commandController,
            validator: requiredValidator,
            minLines: 3,
            maxLines: 7,
            style: const TextStyle(fontFamily: 'monospace'),
            decoration: const InputDecoration(
              labelText: 'Command',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Optional',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: labelsController,
            decoration: const InputDecoration(
              labelText: 'Labels',
              hintText: 'ops, diagnostics',
            ),
          ),
        ],
      ),
    );
  }
}
