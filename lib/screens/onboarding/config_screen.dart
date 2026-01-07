import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_state_provider.dart';
import 'goals_screen.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Path'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.largePadding),

              // Header
              Text(
                'When does your journey begin?',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.largePadding),

              Text(
                'Choose your starting point. This decision is permanent.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.largePadding * 2),

              // Option A: The Purist
              _buildRadioOption(
                value: 'purist',
                title: 'The Purist',
                subtitle: 'Start Date: January 7, 2026',
                description:
                    'Follow the original Project 1356 timeline. Your Day 1 is January 7, 2026.',
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Option B: My Journey
              _buildRadioOption(
                value: 'custom',
                title: 'My Journey',
                subtitle: 'Start Date: Today (${_formatDate(DateTime.now())})',
                description:
                    'Begin your personal transformation today. Your Day 1 starts right now.',
              ),

              const Spacer(),

              // Continue Button
              ElevatedButton(
                onPressed: _selectedOption != null ? _onContinue : null,
                child: const Text('CONTINUE'),
              ),

              const SizedBox(height: AppConstants.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption({
    required String value,
    required String title,
    required String subtitle,
    required String description,
  }) {
    final isSelected = _selectedOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.gridSuccessColor.withOpacity(0.1)
              : AppConstants.gridEmptyColor,
          border: Border.all(
            color: isSelected
                ? AppConstants.gridSuccessColor
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppConstants.gridSuccessColor
                      : AppConstants.textSecondaryColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppConstants.gridSuccessColor,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: AppConstants.defaultPadding),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: isSelected
                              ? AppConstants.gridSuccessColor
                              : AppConstants.textPrimaryColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.textSecondaryColor,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _onContinue() async {
    final prefsService = ref.read(preferencesServiceProvider);

    final DateTime startDate;
    if (_selectedOption == 'purist') {
      startDate = AppConstants.puristStartDate;
    } else {
      startDate = DateTime.now();
    }

    await prefsService.setStartDate(startDate);
    ref.read(startDateProvider.notifier).state = startDate;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const GoalsScreen(),
        ),
      );
    }
  }
}
