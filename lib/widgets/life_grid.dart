import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../providers/app_state_provider.dart';

class LifeGrid extends ConsumerWidget {
  final Function(int dayNumber) onDayTap;

  const LifeGrid({
    super.key,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppConstants.gridCrossAxisCount,
          crossAxisSpacing: AppConstants.gridSpacing,
          mainAxisSpacing: AppConstants.gridSpacing,
        ),
        itemCount: AppConstants.totalDays,
        itemBuilder: (context, index) {
          final dayNumber = index + 1;
          return _GridItem(
            dayNumber: dayNumber,
            onTap: () => onDayTap(dayNumber),
          );
        },
      ),
    );
  }
}

class _GridItem extends ConsumerWidget {
  final int dayNumber;
  final VoidCallback onTap;

  const _GridItem({
    required this.dayNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayState = ref.watch(dayStateProvider(dayNumber));

    final color = _getColorForState(dayState);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
        child: dayState == DayState.pending
            ? _buildPulsingIndicator()
            : null,
      ),
    );
  }

  Color _getColorForState(DayState state) {
    switch (state) {
      case DayState.future:
        return AppConstants.gridFutureColor;
      case DayState.pending:
        return AppConstants.gridPendingColor;
      case DayState.success:
        return AppConstants.gridSuccessColor;
      case DayState.failure:
        return AppConstants.gridFailColor;
    }
  }

  Widget _buildPulsingIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: AppConstants.mediumAnimation,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            decoration: BoxDecoration(
              color: AppConstants.gridPendingColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
      onEnd: () {
        // This will cause the animation to restart
      },
    );
  }
}
