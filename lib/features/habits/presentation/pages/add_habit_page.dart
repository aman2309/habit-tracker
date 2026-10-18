import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/load_status.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/add_habit_cubit.dart';
import '../cubit/add_habit_state.dart';

/// Screen B: create a new habit.
class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController(text: '10');

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<AddHabitCubit>().submit(
      name: _nameController.text,
      description: _descriptionController.text,
      points: _pointsController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add habit'),
        leading: BackButton(onPressed: () => _leave(context)),
      ),
      body: SafeArea(
        child: BlocConsumer<AddHabitCubit, AddHabitState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Habit created.')));
              _leave(context);
            }
          },
          builder: (context, state) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                  ),
                  children: [
                    Text(
                      'New habit',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Give it a clear name and decide how many points it is '
                      'worth.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (state.status == LoadStatus.failure &&
                        state.errorMessage != null)
                      _ErrorBanner(message: state.errorMessage!),
                    TextFormField(
                      key: const Key('add_habit_name_field'),
                      controller: _nameController,
                      enabled: !state.isSubmitting,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 60,
                      decoration: const InputDecoration(
                        labelText: 'Habit name',
                        hintText: 'e.g. Drink 2 litres of water',
                        prefixIcon: Icon(Icons.edit_outlined),
                      ),
                      validator: _validateName,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      key: const Key('add_habit_description_field'),
                      controller: _descriptionController,
                      enabled: !state.isSubmitting,
                      minLines: 3,
                      maxLines: 4,
                      maxLength: 280,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: 'Why does this habit matter?',
                        alignLabelWithHint: true,
                      ),
                      validator: _validateDescription,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      key: const Key('add_habit_points_field'),
                      controller: _pointsController,
                      enabled: !state.isSubmitting,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onFieldSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(
                        labelText: 'Points',
                        hintText: '10',
                        helperText: 'Reward earned each time you complete it',
                        prefixIcon: Icon(Icons.stars_outlined),
                      ),
                      validator: _validatePoints,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      key: const Key('add_habit_submit_button'),
                      onPressed: state.isSubmitting ? null : _submit,
                      child: state.isSubmitting
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md),
                                Text('Saving...'),
                              ],
                            )
                          : const Text('Create habit'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => _leave(context),
                      child: const Text('Cancel'),
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

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.today);
    }
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter a habit name.';
    if (name.length > 60) return 'Use 60 characters or fewer.';
    return null;
  }

  String? _validateDescription(String? value) {
    final description = value?.trim() ?? '';
    if (description.length > 280) return 'Use 280 characters or fewer.';
    return null;
  }

  String? _validatePoints(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return 'Enter the points for this habit.';
    final points = int.tryParse(raw);
    if (points == null) return 'Points must be a whole number.';
    if (points <= 0) return 'Points must be greater than 0.';
    if (points > 10000) return 'Points must be 10000 or less.';
    return null;
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 20,
            color: AppColors.danger,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
