import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/metrics_header.dart';
import '../../widgets/life_grid.dart';
import '../daily_input/daily_input_screen.dart';
import '../day_detail/day_detail_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule notifications when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleNotifications();
    });
  }

  Future<void> _scheduleNotifications() async {
    final startDate = ref.read(startDateProvider);
    if (startDate != null) {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.scheduleDailyNotifications(startDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = ref.watch(currentDayIndexProvider);
    final daysRemaining = ref.watch(daysRemainingProvider);
    final startDate = ref.watch(startDateProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    if (startDate == null || currentDay == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error: Missing start date'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROJECT 1356'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => _toggleTheme(ref),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showGoalsDialog(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Metrics Header
            MetricsHeader(
              currentDay: currentDay,
              daysRemaining: daysRemaining ?? 0,
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // The Life Grid
            Expanded(
              child: LifeGrid(
                onDayTap: (dayNumber) => _handleDayTap(
                  context,
                  ref,
                  dayNumber,
                  currentDay,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Quick Action Button
            if (currentDay <= AppConstants.totalDays)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.largePadding,
                ),
                child: _buildQuickActionButton(context, ref, currentDay),
              ),

            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      BuildContext context, WidgetRef ref, int currentDay) {
    final entryAsync = ref.watch(entryForDayProvider(currentDay));

    return entryAsync.when(
      data: (entry) {
        if (entry != null) {
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DayDetailScreen(dayNumber: currentDay),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.gridSuccessColor.withOpacity(0.3),
            ),
            child: const Text('VIEW TODAY\'S PROOF'),
          );
        } else {
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DailyInputScreen(dayNumber: currentDay),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.gridPendingColor,
            ),
            child: const Text('SUBMIT TODAY\'S PROOF'),
          );
        }
      },
      loading: () => const ElevatedButton(
        onPressed: null,
        child: Text('LOADING...'),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _handleDayTap(
      BuildContext context, WidgetRef ref, int dayNumber, int currentDay) {
    final entryAsync = ref.watch(entryForDayProvider(dayNumber));
    final startDate = ref.watch(startDateProvider);

    if (startDate == null) return;

    entryAsync.whenData((entry) {
      if (entry != null) {
        // Day has entry - show detail
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DayDetailScreen(dayNumber: dayNumber),
          ),
        );
      } else if (dayNumber == currentDay) {
        // Today, no entry - open input
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DailyInputScreen(dayNumber: dayNumber),
          ),
        );
      } else if (dayNumber < currentDay) {
        // Past day, no entry - show failure message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Day Lost - No proof was submitted'),
            backgroundColor: AppConstants.gridFailColor,
          ),
        );
      } else {
        // Future day
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This day hasn\'t arrived yet'),
            backgroundColor: AppConstants.gridEmptyColor,
          ),
        );
      }
    });
  }

  Future<void> _toggleTheme(WidgetRef ref) async {
    final prefsService = ref.read(preferencesServiceProvider);
    final currentMode = ref.read(isDarkModeProvider);

    await prefsService.setDarkMode(!currentMode);
    ref.read(isDarkModeProvider.notifier).state = !currentMode;
  }

  void _showGoalsDialog(BuildContext context, WidgetRef ref) {
    final goals = ref.read(goalsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your 6 Goals'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < goals.length; i++) ...[
                Text(
                  'GOAL ${i + 1}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.gridSuccessColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  goals[i],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (i < goals.length - 1) const SizedBox(height: AppConstants.defaultPadding),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}
