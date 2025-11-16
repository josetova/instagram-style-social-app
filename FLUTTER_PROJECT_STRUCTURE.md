# Flutter Project Structure

```
social_media_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_themes.dart
│   │   │   └── app_constants.dart
│   │   ├── utils/
│   │   │   ├── image_compressor.dart
│   │   │   ├── video_compressor.dart
│   │   │   ├── location_helper.dart
│   │   │   └── validators.dart
│   │   └── services/
│   │       ├── supabase_service.dart
│   │       ├── storage_service.dart
│   │       ├── notification_service.dart
│   │       └── local_storage_service.dart
│   │
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── post_model.dart
│   │   ├── comment_model.dart
│   │   ├── message_model.dart
│   │   ├── community_model.dart
│   │   ├── event_model.dart
│   │   ├── confession_model.dart
│   │   ├── challenge_model.dart
│   │   ├── story_chain_model.dart
│   │   └── friendship_level_model.dart
│   │
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── user_provider.dart
│   │   ├── post_provider.dart
│   │   ├── feed_provider.dart
│   │   ├── message_provider.dart
│   │   ├── notification_provider.dart
│   │   └── theme_provider.dart
│   │
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   │
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   ├── feed_tab.dart
│   │   │   ├── explore_tab.dart
│   │   │   ├── local_feed_tab.dart
│   │   │   └── swipe_feed_screen.dart
│   │   │
│   │   ├── post/
│   │   │   ├── create_post_screen.dart
│   │   │   ├── post_detail_screen.dart
│   │   │   ├── create_duet_screen.dart
│   │   │   ├── repost_template_screen.dart
│   │   │   └── drafts_screen.dart
│   │   │
│   │   ├── story/
│   │   │   ├── story_chain_screen.dart
│   │   │   ├── create_story_chain_screen.dart
│   │   │   ├── reverse_story_screen.dart
│   │   │   └── story_reactions_screen.dart
│   │   │
│   │   ├── profile/
│   │   │   ├── profile_screen.dart
│   │   │   ├── edit_profile_screen.dart
│   │   │   ├── followers_screen.dart
│   │   │   ├── following_screen.dart
│   │   │   ├── saved_posts_screen.dart
│   │   │   ├── liked_posts_screen.dart
│   │   │   ├── locker_screen.dart
│   │   │   └── theme_selector_screen.dart
│   │   │
│   │   ├── messages/
│   │   │   ├── conversations_screen.dart
│   │   │   ├── chat_screen.dart
│   │   │   └── emoji_only_chat_screen.dart
│   │   │
│   │   ├── community/
│   │   │   ├── communities_screen.dart
│   │   │   ├── community_detail_screen.dart
│   │   │   ├── create_community_screen.dart
│   │   │   └── community_feed_screen.dart
│   │   │
│   │   ├── events/
│   │   │   ├── events_screen.dart
│   │   │   ├── event_detail_screen.dart
│   │   │   └── create_event_screen.dart
│   │   │
│   │   ├── confession/
│   │   │   ├── confession_feed_screen.dart
│   │   │   └── create_confession_screen.dart
│   │   │
│   │   ├── challenges/
│   │   │   ├── challenges_screen.dart
│   │   │   ├── challenge_detail_screen.dart
│   │   │   └── submit_challenge_screen.dart
│   │   │
│   │   ├── follow_groups/
│   │   │   ├── follow_groups_screen.dart
│   │   │   ├── create_group_screen.dart
│   │   │   └── group_feed_screen.dart
│   │   │
│   │   └── notifications/
│   │       └── notifications_screen.dart
│   │
│   └── widgets/
│       ├── post_card.dart
│       ├── user_avatar.dart
│       ├── comment_item.dart
│       ├── story_chain_item.dart
│       ├── repost_template_widget.dart
│       ├── friendship_level_badge.dart
│       ├── theme_preview.dart
│       └── custom_button.dart
│
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── frames/
│   │   │   ├── polaroid_frame.png
│   │   │   ├── meme_frame.png
│   │   │   ├── collage_frame.png
│   │   │   └── moodboard_frame.png
│   │   └── themes/
│   │       ├── minimal_preview.png
│   │       ├── neon_preview.png
│   │       ├── dark_preview.png
│   │       ├── pastel_preview.png
│   │       └── sunset_preview.png
│   └── fonts/
│
├── pubspec.yaml
└── README.md
```

## Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Supabase
  supabase_flutter: ^2.0.0
  
  # State Management
  provider: ^6.1.0
  
  # UI
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.9
  image_picker: ^1.0.5
  video_player: ^2.8.1
  photo_view: ^0.14.0
  
  # Location
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
  
  # Media
  image_compression_flutter: ^1.0.4
  video_compress: ^3.1.2
  file_picker: ^6.1.1
  
  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.1
  
  # Audio (for voice notes)
  record: ^5.0.4
  audioplayers: ^5.2.1
  
  # Utils
  intl: ^0.18.1
  timeago: ^3.6.0
  uuid: ^4.2.1
  crypto: ^3.0.3
  
  # Permissions
  permission_handler: ^11.1.0
  
  # Connectivity
  connectivity_plus: ^5.0.2
```
