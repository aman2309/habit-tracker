import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/user_name_cubit.dart';

/// Opens a small dialog that lets the user rename themselves.
Future<void> showRenameDialog(BuildContext context) {
  final cubit = context.read<UserNameCubit>();
  return showDialog<void>(
    context: context,
    builder: (_) => _RenameNameDialog(
      initialName: cubit.state.name,
      onSubmit: cubit.saveName,
    ),
  );
}

class _RenameNameDialog extends StatefulWidget {
  const _RenameNameDialog({required this.initialName, required this.onSubmit});

  final String initialName;
  final ValueChanged<String> onSubmit;

  @override
  State<_RenameNameDialog> createState() => _RenameNameDialogState();
}

class _RenameNameDialogState extends State<_RenameNameDialog> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName)
      ..selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.initialName.length,
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name.');
      return;
    }
    widget.onSubmit(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your name'),
      content: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: 'Display name',
          hintText: 'e.g. Aman',
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 0),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
          ),
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
