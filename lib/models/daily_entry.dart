class DailyEntry {
  final int? id;
  final int dayNumber;
  final String imagePath;
  final String? note;
  final int createdAt;

  DailyEntry({
    this.id,
    required this.dayNumber,
    required this.imagePath,
    this.note,
    required this.createdAt,
  });

  // Convert DailyEntry object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day_number': dayNumber,
      'image_path': imagePath,
      'note': note,
      'created_at': createdAt,
    };
  }

  // Create DailyEntry object from Map
  factory DailyEntry.fromMap(Map<String, dynamic> map) {
    return DailyEntry(
      id: map['id'] as int?,
      dayNumber: map['day_number'] as int,
      imagePath: map['image_path'] as String,
      note: map['note'] as String?,
      createdAt: map['created_at'] as int,
    );
  }

  // Create a copy with updated fields
  DailyEntry copyWith({
    int? id,
    int? dayNumber,
    String? imagePath,
    String? note,
    int? createdAt,
  }) {
    return DailyEntry(
      id: id ?? this.id,
      dayNumber: dayNumber ?? this.dayNumber,
      imagePath: imagePath ?? this.imagePath,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'DailyEntry{id: $id, dayNumber: $dayNumber, imagePath: $imagePath, note: $note, createdAt: $createdAt}';
  }
}
