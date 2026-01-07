import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'config_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Title
              Text(
                '1356',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 64,
                      letterSpacing: 8,
                    ),
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Subtitle
              Text(
                'DAYS TO TRANSFORM',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppConstants.textSecondaryColor,
                      letterSpacing: 2,
                    ),
              ),

              const SizedBox(height: AppConstants.largePadding * 2),

              // Description
              Text(
                'You have 1,356 days.\n\n'
                '6 goals that will change your life.\n\n'
                'Every day matters.\n\n'
                'Miss one, and it turns red forever.\n\n'
                'No excuses. No second chances.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                      color: AppConstants.textSecondaryColor,
                    ),
              ),

              const Spacer(),

              // Memento Mori quote
              Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppConstants.gridSuccessColor.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
                child: Text(
                  '"Remember you must die"\n— Memento Mori',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppConstants.gridSuccessColor,
                      ),
                ),
              ),

              const SizedBox(height: AppConstants.largePadding * 2),

              // Begin Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ConfigScreen(),
                    ),
                  );
                },
                child: const Text('BEGIN'),
              ),

              const SizedBox(height: AppConstants.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
