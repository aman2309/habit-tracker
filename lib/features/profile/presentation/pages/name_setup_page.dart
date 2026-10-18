import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/user_name_cubit.dart';
import '../cubit/user_name_state.dart';

/// First-run screen shown until the user tells us their name.
///
/// The name is only used for the greeting; it is stored locally and can be
/// changed later from the Today screen.
class NameSetupPage extends StatefulWidget {
  const NameSetupPage({super.key});

  @override
  State<NameSetupPage> createState() => _NameSetupPageState();
}

class _NameSetupPageState extends State<NameSetupPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<UserNameCubit>().saveName(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: BlocBuilder<UserNameCubit, UserNameState>(
                builder: (context, state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceMuted,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.waving_hand_rounded,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Welcome!', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'What should we call you? We use your name to greet you '
                      'on the Today screen.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    TextField(
                      key: const Key('name_setup_field'),
                      controller: _controller,
                      autofocus: true,
                      enabled: !state.isSaving,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      maxLength: UserNameCubit.maxNameLength,
                      onSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        labelText: 'Your name',
                        hintText: 'Enter Your Name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        state.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      key: const Key('name_setup_button'),
                      onPressed: state.isSaving ? null : _submit,
                      child: state.isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
