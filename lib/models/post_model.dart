class PostModel {
  final String id;
  final String userId;
  final String? caption;
  final List<String> mediaUrls;
  final String mediaType;
  final String? locationName;
  final double? locationLat;
  final double? locationLng;
  final List<String> hashtags;
  final bool isDraft;
  final DateTime? timeLockedUntil;
  final String visibility;
  final String? groupId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields from joins
  String? username;
  String? userProfilePhoto;
  int? likesCount;
  int? commentsCount;
  bool? isLiked;
  bool? isSaved;

  PostModel({
    required this.id,
    required this.userId,
    this.caption,
    required this.mediaUrls,
    required this.mediaType,
    this.locationName,
    this.locationLat,
    this.locationLng,
    this.hashtags = const [],
    this.isDraft = false,
    this.timeLockedUntil,
    this.visibility = 'public',
    this.groupId,
    required this.createdAt,
    required this.updatedAt,
    this.username,
    this.userProfilePhoto,
    this.likesCount,
    this.commentsCount,
    this.isLiked,
    this.isSaved,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['user_id'],
      caption: json['caption'],
      mediaUrls: List<String>.from(json['media_urls'] ?? []),
      mediaType: json['media_type'],
      locationName: json['location_name'],
      locationLat: json['location_lat'],
      locationLng: json['location_lng'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      isDraft: json['is_draft'] ?? false,
      timeLockedUntil: json['time_locked_until'] != null
          ? DateTime.parse(json['time_locked_until'])
          : null,
      visibility: json['visibility'] ?? 'public',
      groupId: json['group_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      username: json['username'],
      userProfilePhoto: json['profile_photo_url'],
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      isLiked: json['is_liked'],
      isSaved: json['is_saved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'caption': caption,
      'media_urls': mediaUrls,
      'media_type': mediaType,
      'location_name': locationName,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'hashtags': hashtags,
      'is_draft': isDraft,
      'time_locked_until': timeLockedUntil?.toIso8601String(),
      'visibility': visibility,
      'group_id': groupId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
