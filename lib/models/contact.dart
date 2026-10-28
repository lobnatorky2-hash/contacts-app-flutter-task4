class Contact {
  const Contact({
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
  });

  final String name;
  final String email;
  final String phone;

  /// Path of the image picked from the device gallery (null if none picked).
  final String? imagePath;
}
