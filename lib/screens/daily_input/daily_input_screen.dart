import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_constants.dart';
import '../../models/daily_entry.dart';
import '../../providers/app_state_provider.dart';

class DailyInputScreen extends ConsumerStatefulWidget {
  final int dayNumber;

  const DailyInputScreen({
    super.key,
    required this.dayNumber,
  });

  @override
  ConsumerState<DailyInputScreen> createState() => _DailyInputScreenState();
}

class _DailyInputScreenState extends ConsumerState<DailyInputScreen> {
  final _noteController = TextEditingController();
  final _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day ${widget.dayNumber}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Proof of Day ${widget.dayNumber}',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              Text(
                'Document today\'s progress with a photo and note.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.largePadding * 2),

              // Image Picker
              _buildImagePicker(),

              const SizedBox(height: AppConstants.largePadding),

              // Note Input
              Text(
                'TODAY\'S PROGRESS (OPTIONAL)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.gridSuccessColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
              const SizedBox(height: AppConstants.smallPadding),

              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'What did you accomplish today?',
                ),
                maxLines: 5,
                maxLength: 500,
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Submit Button
              ElevatedButton(
                onPressed: _selectedImagePath != null && !_isSubmitting
                    ? _onSubmit
                    : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('SUBMIT PROOF'),
              ),

              if (_selectedImagePath == null) ...[
                const SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'A photo is required to submit proof',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.gridFailColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppConstants.gridEmptyColor,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(
            color: _selectedImagePath != null
                ? AppConstants.gridSuccessColor
                : AppConstants.textSecondaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: _selectedImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                child: Image.file(
                  File(_selectedImagePath!),
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 64,
                    color: AppConstants.textSecondaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'Tap to capture or select photo',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_selectedImagePath == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final fileService = ref.read(fileStorageServiceProvider);
      final dbService = ref.read(databaseServiceProvider);

      // Save image to app storage
      final savedImagePath = await fileService.saveImage(
        _selectedImagePath!,
        widget.dayNumber,
      );

      // Create entry
      final entry = DailyEntry(
        dayNumber: widget.dayNumber,
        imagePath: savedImagePath,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Save to database
      await dbService.insertEntry(entry);

      // Invalidate providers to refresh UI
      ref.invalidate(dailyEntriesProvider);
      ref.invalidate(entryForDayProvider(widget.dayNumber));
      ref.invalidate(completedDaysCountProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proof submitted successfully!'),
            backgroundColor: AppConstants.gridSuccessColor,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppConstants.gridFailColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
