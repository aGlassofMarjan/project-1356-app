import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_state_provider.dart';

class DayDetailScreen extends ConsumerWidget {
  final int dayNumber;

  const DayDetailScreen({
    super.key,
    required this.dayNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(entryForDayProvider(dayNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text('Day $dayNumber'),
      ),
      body: entryAsync.when(
        data: (entry) {
          if (entry == null) {
            return const Center(
              child: Text('No entry found for this day'),
            );
          }

          final dateFormatter = DateFormat('MMMM d, yyyy - h:mm a');
          final submittedDate = DateTime.fromMillisecondsSinceEpoch(entry.createdAt);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                if (File(entry.imagePath).existsSync())
                  Image.file(
                    File(entry.imagePath),
                    fit: BoxFit.cover,
                    height: 400,
                  )
                else
                  Container(
                    height: 400,
                    color: AppConstants.gridEmptyColor,
                    child: const Center(
                      child: Text('Image not found'),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day Number
                      Text(
                        'DAY $dayNumber',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppConstants.gridSuccessColor,
                              letterSpacing: 2,
                            ),
                      ),

                      const SizedBox(height: AppConstants.smallPadding),

                      // Submission timestamp
                      Text(
                        'Submitted: ${dateFormatter.format(submittedDate)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppConstants.textSecondaryColor,
                            ),
                      ),

                      const SizedBox(height: AppConstants.largePadding),

                      // Note section
                      if (entry.note != null && entry.note!.isNotEmpty) ...[
                        Text(
                          'PROGRESS NOTES',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppConstants.gridSuccessColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Container(
                          padding: const EdgeInsets.all(AppConstants.defaultPadding),
                          decoration: BoxDecoration(
                            color: AppConstants.gridEmptyColor,
                            borderRadius: BorderRadius.circular(
                              AppConstants.defaultBorderRadius,
                            ),
                          ),
                          child: Text(
                            entry.note!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'No notes for this day',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppConstants.textSecondaryColor,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],

                      const SizedBox(height: AppConstants.largePadding),

                      // Success message
                      Container(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        decoration: BoxDecoration(
                          color: AppConstants.gridSuccessColor.withOpacity(0.1),
                          border: Border.all(
                            color: AppConstants.gridSuccessColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.defaultBorderRadius,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppConstants.gridSuccessColor,
                            ),
                            const SizedBox(width: AppConstants.defaultPadding),
                            Expanded(
                              child: Text(
                                'Day completed successfully',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppConstants.gridSuccessColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
