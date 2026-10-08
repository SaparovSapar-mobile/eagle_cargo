extension FormatUtcExtension on String? {
  String convert2Local() {
    if (this == null) return "";
    String parsed = DateTime.parse(this!).toLocal().toString();
    String year = parsed.split("-")[0];
    String month = parsed.split("-")[1];
    String day = parsed.split("-")[2].split(" ")[0];
    String hour = parsed.split(" ")[1].split(":")[0];
    String minute = parsed.split(" ")[1].split(":")[1];
    // return parsed.split("-")[2];
    return "$day.$month.$year $hour:$minute";
  }

  String toSentenceCase() {
    // if (isEmpty!) return "";

    String lower = this!.toLowerCase(); // hello world
    return lower[0].toUpperCase() + lower.substring(1);
  }

  String parseTime() {
    //2025-12-01T11:07:46.530Z
    if (this == null) return '';
    String year = this?.split('T')[0].split('-')[0] ?? '';
    String month = this?.split('T')[0].split('-')[1] ?? '';
    String day = this?.split('T')[0].split('-')[2] ?? '';
    String hour = this?.split('T')[1].split(':')[0] ?? '';
    String minute = this?.split('T')[1].split(':')[1] ?? '';
    String second = this?.split('T')[1].split(':')[2].split('.')[0] ?? '';
    return "$day.$month.$year $hour:$minute:$second";
  }

  String driveImage() {
    return (this != null || (this?.isEmpty ?? true))
        ? 'https://drive.usercontent.google.com/download?id=$this&export=view'
        : '';
    // return (this != null || (this?.isEmpty ?? true))
    //     ? 'https://drive.usercontent.google.com/download?id=$this&export=media&authuser=0'
    //     : '';
  }
}

extension DimensionExtension on Map<String, dynamic> {
  /// Safely parses dimension value (can be null, string, int, double)
  double? _parseDimension(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || trimmed == "null" || trimmed == "0") return null;
      return double.tryParse(trimmed);
    }
    return null;
  }

  /// Returns "16x50x20 cm" only if ALL three dimensions are valid (> 0)
  String? get formattedDimensions {
    final length = _parseDimension(this['length_cm']);
    final width = _parseDimension(this['width_cm']);
    final height = _parseDimension(this['height_cm']);

    if (length != null &&
        width != null &&
        height != null &&
        length > 0 &&
        width > 0 &&
        height > 0) {
      return "${length.toInt()}x${width.toInt()}x${height.toInt()} cm";
    }

    return null; // Hide if any is missing/invalid
  }
}
