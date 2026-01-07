class DateCalculator {
  static const int totalDays = 1356;

  // Calculate the current day index (1-1356) based on start date
  static int getCurrentDayIndex(DateTime startDate) {
    final today = DateTime.now();
    final difference = today.difference(startDate).inDays;
    return difference + 1; // Day 1 starts on start date
  }

  // Calculate days remaining
  static int getDaysRemaining(DateTime startDate) {
    final currentDay = getCurrentDayIndex(startDate);
    if (currentDay > totalDays) return 0;
    return totalDays - currentDay + 1;
  }

  // Check if the project is complete
  static bool isProjectComplete(DateTime startDate) {
    return getCurrentDayIndex(startDate) > totalDays;
  }

  // Get the date for a specific day number
  static DateTime getDateForDayNumber(DateTime startDate, int dayNumber) {
    return startDate.add(Duration(days: dayNumber - 1));
  }

  // Check if a day number is in the future
  static bool isDayInFuture(DateTime startDate, int dayNumber) {
    final currentDay = getCurrentDayIndex(startDate);
    return dayNumber > currentDay;
  }

  // Check if a day number is today
  static bool isDayToday(DateTime startDate, int dayNumber) {
    final currentDay = getCurrentDayIndex(startDate);
    return dayNumber == currentDay;
  }

  // Check if a day number is in the past
  static bool isDayInPast(DateTime startDate, int dayNumber) {
    final currentDay = getCurrentDayIndex(startDate);
    return dayNumber < currentDay;
  }

  // Get the end date of the project
  static DateTime getProjectEndDate(DateTime startDate) {
    return startDate.add(const Duration(days: totalDays - 1));
  }

  // Calculate the percentage of days completed (0.0 to 1.0)
  static double getProgressPercentage(DateTime startDate) {
    final currentDay = getCurrentDayIndex(startDate);
    if (currentDay > totalDays) return 1.0;
    return (currentDay - 1) / totalDays;
  }

  // Get time remaining until midnight (for today's deadline)
  static Duration getTimeUntilMidnight() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  // Check if we're within the warning period (e.g., last 3 hours of the day)
  static bool isInWarningPeriod({int warningHours = 3}) {
    final timeRemaining = getTimeUntilMidnight();
    return timeRemaining.inHours < warningHours;
  }
}
