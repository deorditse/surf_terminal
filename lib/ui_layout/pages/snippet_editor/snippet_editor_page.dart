import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/shared/widgets/surf_components.dart';

class SnippetEditorPage extends StatefulWidget {
  const SnippetEditorPage({this.snippetId, super.key});

  final String? snippetId;

  @override
  State<SnippetEditorPage> createState() => _SnippetEditorPageState();
}

class _SnippetEditorPageState extends State<SnippetEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _command;
  late final TextEditingController _description;
  late final TextEditingController _labels;
  CommandSnippet? _existing;

  @override
  void initState() {
    super.initState();
    _existing = widget.snippetId == null
        ? null
        : context
              .read<SnippetsCubit>()
              .state
              .snippets
              .where((item) => item.id == widget.snippetId)
              .firstOrNull;
    _title = TextEditingController(text: _existing?.title ?? '');
    _command = TextEditingController(text: _existing?.command ?? '');
    _description = TextEditingController(text: _existing?.description ?? '');
    _labels = TextEditingController(text: _existing?.labels.join(', ') ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _command.dispose();
    _description.dispose();
    _labels.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<SnippetsCubit>();
    final labels = _labels.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    final snippet =
        _existing?.copyWith(
          title: _title.text.trim(),
          command: _command.text.trim(),
          description: _description.text.trim(),
          labels: labels,
        ) ??
        cubit.createSnippet(
          title: _title.text.trim(),
          command: _command.text.trim(),
          description: _description.text.trim(),
          labels: labels,
        );
    cubit.saveSnippet(snippet);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('snippet-editor-page'),
      appBar: AppBar(
        title: Text(_existing == null ? 'New snippet' : 'Edit snippet'),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              const PageIntro(
                eyebrow: 'Reusable command',
                title: 'Shape a shortcut',
                description:
                    'Snippets live in memory for the current preview run.',
              ),
              const SizedBox(height: 24),
              SurfSection(
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('snippet-title'),
                      controller: _title,
                      validator: _required,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const Key('snippet-command'),
                      controller: _command,
                      validator: _required,
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
                      controller: _description,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Optional',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _labels,
                      decoration: const InputDecoration(
                        labelText: 'Labels',
                        hintText: 'ops, diagnostics',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const Key('save-snippet'),
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(
                  _existing == null ? 'Create snippet' : 'Save changes',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
