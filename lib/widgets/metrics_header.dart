import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class MetricsHeader extends StatelessWidget {
  final int currentDay;
  final int daysRemaining;

  const MetricsHeader({
    super.key,
    required this.currentDay,
    required this.daysRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        children: [
          // Current Day
          Text(
            'DAY $currentDay OF ${AppConstants.totalDays}',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppConstants.gridSuccessColor,
                  letterSpacing: 2,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.smallPadding),

          // Days Remaining
          Text(
            '$daysRemaining DAYS REMAINING',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.textSecondaryColor,
                  letterSpacing: 1.5,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Progress Bar
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (currentDay - 1) / AppConstants.totalDays;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppConstants.gridEmptyColor,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppConstants.gridSuccessColor,
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toStringAsFixed(1)}% Complete',
          style: const TextStyle(
            fontSize: 10,
            color: AppConstants.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
