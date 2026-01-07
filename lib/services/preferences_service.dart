import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('PreferencesService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Keys
  static const String _keyStartDateEpoch = 'start_date_epoch';
  static const String _keyIsSetupComplete = 'is_setup_complete';
  static const String _keyGoal1 = 'goal_1';
  static const String _keyGoal2 = 'goal_2';
  static const String _keyGoal3 = 'goal_3';
  static const String _keyGoal4 = 'goal_4';
  static const String _keyGoal5 = 'goal_5';
  static const String _keyGoal6 = 'goal_6';
  static const String _keyIsDarkMode = 'is_dark_mode';

  // Start Date
  Future<void> setStartDate(DateTime startDate) async {
    await prefs.setInt(_keyStartDateEpoch, startDate.millisecondsSinceEpoch);
  }

  DateTime? getStartDate() {
    final epoch = prefs.getInt(_keyStartDateEpoch);
    if (epoch == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(epoch);
  }

  // Setup Complete
  Future<void> setSetupComplete(bool isComplete) async {
    await prefs.setBool(_keyIsSetupComplete, isComplete);
  }

  bool isSetupComplete() {
    return prefs.getBool(_keyIsSetupComplete) ?? false;
  }

  // Goals
  Future<void> setGoals(List<String> goals) async {
    if (goals.length != 6) {
      throw ArgumentError('Must provide exactly 6 goals');
    }

    await prefs.setString(_keyGoal1, goals[0]);
    await prefs.setString(_keyGoal2, goals[1]);
    await prefs.setString(_keyGoal3, goals[2]);
    await prefs.setString(_keyGoal4, goals[3]);
    await prefs.setString(_keyGoal5, goals[4]);
    await prefs.setString(_keyGoal6, goals[5]);
  }

  List<String> getGoals() {
    return [
      prefs.getString(_keyGoal1) ?? '',
      prefs.getString(_keyGoal2) ?? '',
      prefs.getString(_keyGoal3) ?? '',
      prefs.getString(_keyGoal4) ?? '',
      prefs.getString(_keyGoal5) ?? '',
      prefs.getString(_keyGoal6) ?? '',
    ];
  }

  String? getGoal(int index) {
    if (index < 1 || index > 6) {
      throw ArgumentError('Goal index must be between 1 and 6');
    }

    switch (index) {
      case 1:
        return prefs.getString(_keyGoal1);
      case 2:
        return prefs.getString(_keyGoal2);
      case 3:
        return prefs.getString(_keyGoal3);
      case 4:
        return prefs.getString(_keyGoal4);
      case 5:
        return prefs.getString(_keyGoal5);
      case 6:
        return prefs.getString(_keyGoal6);
      default:
        return null;
    }
  }

  // Clear all data (for testing or reset)
  Future<void> clearAll() async {
    await prefs.clear();
  }

  // Theme Mode
  Future<void> setDarkMode(bool isDarkMode) async {
    await prefs.setBool(_keyIsDarkMode, isDarkMode);
  }

  bool isDarkMode() {
    return prefs.getBool(_keyIsDarkMode) ?? false; // Default to light theme
  }

  // Check if all required data is set
  bool hasCompleteConfig() {
    final startDate = getStartDate();
    final goals = getGoals();
    final setupComplete = isSetupComplete();

    return startDate != null &&
        goals.every((goal) => goal.isNotEmpty) &&
        setupComplete;
  }
}
