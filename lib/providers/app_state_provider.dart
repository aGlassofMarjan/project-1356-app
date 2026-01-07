import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';
import '../services/file_storage_service.dart';
import '../services/preferences_service.dart';
import '../services/notification_service.dart';
import '../models/daily_entry.dart';
import '../utils/date_calculator.dart';

// Service Providers
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final fileStorageServiceProvider = Provider<FileStorageService>((ref) {
  return FileStorageService();
});

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// Start Date Provider
final startDateProvider = StateProvider<DateTime?>((ref) {
  final prefsService = ref.watch(preferencesServiceProvider);
  return prefsService.getStartDate();
});

// Setup Complete Provider
final setupCompleteProvider = StateProvider<bool>((ref) {
  final prefsService = ref.watch(preferencesServiceProvider);
  return prefsService.isSetupComplete();
});

// Goals Provider
final goalsProvider = StateProvider<List<String>>((ref) {
  final prefsService = ref.watch(preferencesServiceProvider);
  return prefsService.getGoals();
});

// Theme Mode Provider
final isDarkModeProvider = StateProvider<bool>((ref) {
  final prefsService = ref.watch(preferencesServiceProvider);
  return prefsService.isDarkMode();
});

// Current Day Index Provider
final currentDayIndexProvider = Provider<int?>((ref) {
  final startDate = ref.watch(startDateProvider);
  if (startDate == null) return null;
  return DateCalculator.getCurrentDayIndex(startDate);
});

// Days Remaining Provider
final daysRemainingProvider = Provider<int?>((ref) {
  final startDate = ref.watch(startDateProvider);
  if (startDate == null) return null;
  return DateCalculator.getDaysRemaining(startDate);
});

// Project Complete Provider
final projectCompleteProvider = Provider<bool>((ref) {
  final startDate = ref.watch(startDateProvider);
  if (startDate == null) return false;
  return DateCalculator.isProjectComplete(startDate);
});

// Daily Entries Provider (FutureProvider)
final dailyEntriesProvider = FutureProvider<List<DailyEntry>>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getAllEntries();
});

// Entry for specific day provider
final entryForDayProvider = FutureProvider.family<DailyEntry?, int>((ref, dayNumber) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getEntryByDayNumber(dayNumber);
});

// Completed days count provider
final completedDaysCountProvider = FutureProvider<int>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return await dbService.getCompletedDaysCount();
});

// Grid state provider - determines color for each day
enum DayState { future, pending, success, failure }

final dayStateProvider = Provider.family<DayState, int>((ref, dayNumber) {
  final startDate = ref.watch(startDateProvider);
  if (startDate == null) return DayState.future;

  final currentDay = DateCalculator.getCurrentDayIndex(startDate);

  // Future day
  if (dayNumber > currentDay) {
    return DayState.future;
  }

  // Check if entry exists for this day
  final entryAsync = ref.watch(entryForDayProvider(dayNumber));

  return entryAsync.when(
    data: (entry) {
      if (entry != null) {
        return DayState.success;
      } else if (dayNumber == currentDay) {
        return DayState.pending;
      } else {
        return DayState.failure;
      }
    },
    loading: () => DayState.future,
    error: (_, __) => DayState.failure,
  );
});
