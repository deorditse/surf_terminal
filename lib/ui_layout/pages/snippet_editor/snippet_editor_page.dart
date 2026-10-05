import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surf_terminal/business_layout/business_layout.dart';
import 'package:surf_terminal/domain_layout/domain_layout.dart';
import 'package:surf_terminal/ui_layout/pages/snippet_editor/widgets/snippet_form_fields.dart';
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
              .read<SnippetsBloc>()
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
    final bloc = context.read<SnippetsBloc>();
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
        bloc.createSnippet(
          title: _title.text.trim(),
          command: _command.text.trim(),
          description: _description.text.trim(),
          labels: labels,
        );
    bloc.add(SnippetsEvent.snippetSaved(snippet));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('snippet-editor-page'),
      extendBodyBehindAppBar: true,
      appBar: ManagementAppBar(
        title: Text(_existing == null ? 'New snippet' : 'Edit snippet'),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            key: const PageStorageKey('snippet-editor-scroll'),
            padding: EdgeInsets.fromLTRB(
              16,
              managementScrollTopPadding(context),
              16,
              32,
            ),
            children: [
              const PageIntro(
                eyebrow: 'Command',
                title: 'Snippet',
                description: 'Store a reusable command.',
              ),
              const SizedBox(height: 24),
              SnippetFormFields(
                titleController: _title,
                commandController: _command,
                descriptionController: _description,
                labelsController: _labels,
                requiredValidator: _required,
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
