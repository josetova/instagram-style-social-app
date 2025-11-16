class UserModel {
  final String id;
  final String? email;
  final String? phone;
  final String username;
  final String name;
  final String? bio;
  final String? profilePhotoUrl;
  final String? customStatus;
  final String profileTheme;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    this.email,
    this.phone,
    required this.username,
    required this.name,
    this.bio,
    this.profilePhotoUrl,
    this.customStatus,
    this.profileTheme = 'minimal',
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      name: json['name'],
      bio: json['bio'],
      profilePhotoUrl: json['profile_photo_url'],
      customStatus: json['custom_status'],
      profileTheme: json['profile_theme'] ?? 'minimal',
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'username': username,
      'name': name,
      'bio': bio,
      'profile_photo_url': profilePhotoUrl,
      'custom_status': customStatus,
      'profile_theme': profileTheme,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
