import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/habit.dart';
import '../cubit/edit_habit_cubit.dart';
import '../cubit/edit_habit_state.dart';
import '../widgets/state_views.dart';

/// Screen: edit an existing habit.
class EditHabitPage extends StatefulWidget {
  const EditHabitPage({super.key, required this.habitId});

  final String habitId;

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final habit = context.read<EditHabitCubit>().state.habit;
    if (habit != null) {
      _seed(habit);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _seed(Habit habit) {
    if (_seeded) return;
    _seeded = true;
    _nameController.text = habit.name;
    _descriptionController.text = habit.description;
    _pointsController.text = '${habit.points}';
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<EditHabitCubit>().save(
      name: _nameController.text,
      description: _descriptionController.text,
      points: _pointsController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit habit'),
        leading: BackButton(onPressed: () => _leave(context)),
      ),
      body: SafeArea(
        child: BlocConsumer<EditHabitCubit, EditHabitState>(
          listenWhen: (previous, current) =>
              previous.habit != current.habit ||
              previous.isSaved != current.isSaved,
          listener: (context, state) {
            final habit = state.habit;
            if (habit != null) _seed(habit);
            if (state.isSaved) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Habit updated.')));
              _leave(context, forceReload: true);
            }
          },
          builder: (context, state) {
            if (state.isLoadingHabit) {
              return const LoadingStateView(message: 'Loading habit...');
            }

            if (!state.hasHabit) {
              return ErrorStateView(
                failure: state.failure!,
                onRetry: () =>
                    context.read<EditHabitCubit>().load(widget.habitId),
              );
            }

            return _buildForm(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, EditHabitState state) {
    return Center(
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
                'Update habit',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Change the name, description or points at any time.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.inkSoft),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (state.failure != null)
                _ErrorBanner(message: state.failure!.message),
              TextFormField(
                key: const Key('edit_habit_name_field'),
                controller: _nameController,
                enabled: !state.isSaving,
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
                key: const Key('edit_habit_description_field'),
                controller: _descriptionController,
                enabled: !state.isSaving,
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
                key: const Key('edit_habit_points_field'),
                controller: _pointsController,
                enabled: !state.isSaving,
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
                key: const Key('edit_habit_submit_button'),
                onPressed: state.isSaving ? null : _submit,
                child: state.isSaving
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
                    : const Text('Save changes'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: state.isSaving ? null : () => _leave(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _leave(BuildContext context, {bool forceReload = false}) {
    if (context.canPop()) {
      context.pop(forceReload);
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
