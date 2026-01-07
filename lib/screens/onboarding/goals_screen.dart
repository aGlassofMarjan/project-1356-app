import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_state_provider.dart';
import '../dashboard/dashboard_screen.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Define Your Goals'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.defaultPadding),

                // Header
                Text(
                  '6 Goals. 1,356 Days.',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                Text(
                  'Choose wisely. These goals will define your journey.\n'
                  'All fields are required.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.largePadding * 2),

                // Goal Input Fields
                for (int i = 0; i < 6; i++) ...[
                  _buildGoalField(i),
                  const SizedBox(height: AppConstants.defaultPadding),
                ],

                const SizedBox(height: AppConstants.largePadding),

                // Commit Button
                ElevatedButton(
                  onPressed: _onCommit,
                  child: const Text('COMMIT'),
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                // Warning text
                Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppConstants.gridFailColor.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                  child: Text(
                    '⚠ Once you commit, there is no going back.\n'
                    'Every day counts. Every miss is permanent.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.gridFailColor,
                        ),
                  ),
                ),

                const SizedBox(height: AppConstants.defaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GOAL ${index + 1}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.gridSuccessColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        TextFormField(
          controller: _controllers[index],
          decoration: InputDecoration(
            hintText: 'What do you want to achieve?',
            counterText: '',
          ),
          maxLength: 100,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This goal cannot be empty';
            }
            return null;
          },
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Future<void> _onCommit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final goals = _controllers.map((c) => c.text.trim()).toList();
    final prefsService = ref.read(preferencesServiceProvider);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you ready to commit to these 6 goals for the next 1,356 days?',
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: AppConstants.gridFailColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('I COMMIT'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Save goals and mark setup as complete
    await prefsService.setGoals(goals);
    await prefsService.setSetupComplete(true);

    ref.read(goalsProvider.notifier).state = goals;
    ref.read(setupCompleteProvider.notifier).state = true;

    // Request notification permissions and schedule notifications
    final notificationService = ref.read(notificationServiceProvider);
    final startDate = ref.read(startDateProvider);

    if (startDate != null) {
      final permissionGranted = await notificationService.requestPermissions();

      if (permissionGranted && mounted) {
        await notificationService.scheduleDailyNotifications(startDate);
      }
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }
}
