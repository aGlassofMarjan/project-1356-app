import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileStorageService {
  static final FileStorageService _instance = FileStorageService._internal();
  factory FileStorageService() => _instance;
  FileStorageService._internal();

  // Get the app's document directory
  Future<Directory> get _appDocDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  // Get the images directory (create if doesn't exist)
  Future<Directory> get _imagesDirectory async {
    final appDir = await _appDocDirectory;
    final imagesDir = Directory(path.join(appDir.path, 'daily_images'));

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    return imagesDir;
  }

  // Save an image file to app storage
  // Returns the new file path
  Future<String> saveImage(String sourcePath, int dayNumber) async {
    final sourceFile = File(sourcePath);

    if (!await sourceFile.exists()) {
      throw Exception('Source file does not exist: $sourcePath');
    }

    final imagesDir = await _imagesDirectory;
    final extension = path.extension(sourcePath);
    final fileName = 'day_${dayNumber}_${DateTime.now().millisecondsSinceEpoch}$extension';
    final destinationPath = path.join(imagesDir.path, fileName);

    // Copy the file to our app storage
    await sourceFile.copy(destinationPath);

    return destinationPath;
  }

  // Get an image file for a specific path
  Future<File?> getImage(String imagePath) async {
    final file = File(imagePath);

    if (await file.exists()) {
      return file;
    }

    return null;
  }

  // Delete an image file
  Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);

      if (await file.exists()) {
        await file.delete();
        return true;
      }

      return false;
    } catch (e) {
      // Log error silently
      return false;
    }
  }

  // Get all image files in storage
  Future<List<File>> getAllImages() async {
    final imagesDir = await _imagesDirectory;

    if (!await imagesDir.exists()) {
      return [];
    }

    final entities = imagesDir.listSync();
    return entities
        .whereType<File>()
        .where((file) => _isImageFile(file.path))
        .toList();
  }

  // Check if file is an image based on extension
  bool _isImageFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(extension);
  }

  // Get total storage size used by images (in bytes)
  Future<int> getTotalStorageSize() async {
    final images = await getAllImages();
    int totalSize = 0;

    for (var image in images) {
      totalSize += await image.length();
    }

    return totalSize;
  }

  // Clear all images (use with caution!)
  Future<void> clearAllImages() async {
    final imagesDir = await _imagesDirectory;

    if (await imagesDir.exists()) {
      await imagesDir.delete(recursive: true);
      await imagesDir.create();
    }
  }
}
