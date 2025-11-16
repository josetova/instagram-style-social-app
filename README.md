# 📱 Instagram-Style Social Media App MVP

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-green.svg)](https://supabase.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A complete, feature-rich social media application built with Flutter and Supabase, featuring 50+ unique non-AI features for enhanced user engagement.

![App Preview](https://via.placeholder.com/800x400/4A90E2/FFFFFF?text=Social+Media+App+MVP)

## ⭐ Star this repo if you find it useful!

## 🚀 Features

### Core Features
- ✅ Email & phone authentication
- ✅ User profiles with customizable themes
- ✅ Photo & video posting with captions
- ✅ Hashtags & location tagging
- ✅ Like, comment, follow/unfollow
- ✅ Direct messaging with emoji-only mode
- ✅ Real-time notifications
- ✅ Home feed, Explore feed, Local feed
- ✅ Saved posts & liked posts
- ✅ Offline drafts

### 🔥 Unique Features

#### Local & Community
- **Local Feed (1-3km)**: Discover posts from people nearby
- **Communities**: Join college, city, or workplace communities
- **Nearby Events**: Create and discover local events

#### Posting Features
- **Time-Locked Posts**: Schedule posts to unlock at specific times
- **Story Chains**: Collaborative stories where followers add content
- **Reverse Stories**: Create frames for followers to fill with their photos
- **Repost Templates**: Polaroid, Meme, Collage, and Mood-board frames

#### Interaction Features
- **Duet Posts**: Split-screen posts with another user
- **Voice Note Comments**: Add voice comments to posts
- **Emoji-Only DM Mode**: Chat using only emojis
- **Friendship Levels**: Bronze → Silver → Gold → Platinum based on interactions
- **Follow Groups**: Organize friends into groups (Best friends, College, Gym squad)

#### Anonymous & Fun
- **Anonymous Confessions**: Post and vote on anonymous confessions
- **Weekly Challenges**: Photography, room setup, fit check challenges
- **Swipe Feed**: Tinder-style post discovery

#### Personalization
- **Profile Themes**: Minimal, Neon, Dark, Pastel, Sunset
- **Custom Status**: Display your current mood/activity
- **Private Locker**: PIN-protected private photo storage

#### Small Useful Features
- Story reactions as stickers
- Auto-delete messages (1 hour, 24 hours, 1 week)
- Offline drafts for posts

## 📁 Project Structure

```
social_media_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app.dart                  # Root widget
│   ├── core/
│   │   ├── constants/            # App constants & themes
│   │   ├── utils/                # Helper utilities
│   │   └── services/             # Supabase & storage services
│   ├── models/                   # Data models
│   ├── providers/                # State management
│   ├── screens/                  # UI screens
│   └── widgets/                  # Reusable widgets
├── assets/                       # Images, fonts, etc.
├── DATABASE_SCHEMA.sql           # Complete database schema
├── API_ENDPOINTS.md              # API documentation
├── DEPLOYMENT_GUIDE.md           # Deployment instructions
└── pubspec.yaml                  # Dependencies
```

## 🛠️ Tech Stack

- **Frontend**: Flutter (iOS, Android, Web)
- **Backend**: Supabase (PostgreSQL + Real-time + Storage + Auth)
- **Storage**: Supabase Storage with CDN
- **Maps**: flutter_map + OpenStreetMap (free)
- **State Management**: Provider

## 📦 Installation

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Supabase account
- Android Studio / Xcode (for mobile development)

### Setup

1. **Clone the repository**
```bash
git clone <repository-url>
cd social_media_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Set up Supabase**
   - Create a new project at [supabase.com](https://supabase.com)
   - Run the SQL from `DATABASE_SCHEMA.sql` in the SQL Editor
   - Configure storage buckets (see DEPLOYMENT_GUIDE.md)
   - Enable Row Level Security policies

4. **Configure app**
   - Update `lib/main.dart` with your Supabase URL and anon key:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

5. **Run the app**
```bash
flutter run
```

## 🗄️ Database Schema

The app uses PostgreSQL with PostGIS for location features. Key tables:

- `users` - User profiles and settings
- `posts` - Photo/video posts with metadata
- `likes`, `comments`, `follows` - Social interactions
- `messages`, `conversations` - Direct messaging
- `communities`, `events` - Community features
- `confessions`, `challenges` - Fun features
- `story_chains`, `reverse_stories` - Collaborative content
- `friendship_levels` - Gamification
- `locker_posts` - Private storage

See `DATABASE_SCHEMA.sql` for complete schema.

## 🔌 API Endpoints

All API interactions use Supabase client. Key operations:

- Authentication: `supabase.auth.signUp()`, `signIn()`, `signOut()`
- Database: `supabase.from('table').select()`, `insert()`, `update()`, `delete()`
- Storage: `supabase.storage.from('bucket').upload()`
- Real-time: `supabase.from('table').stream()`

See `API_ENDPOINTS.md` for detailed documentation.

## 🎨 UI Screens

### Main Screens
1. **Authentication**: Login, Signup, Forgot Password
2. **Home**: Feed, Explore, Local Feed, Swipe Feed
3. **Create Post**: Photo/video upload, captions, location
4. **Messages**: Conversations, Chat, Emoji-only mode
5. **Profile**: Posts grid, Followers, Following, Settings

### Feature Screens
- Story Chains & Reverse Stories
- Duet Posts & Repost Templates
- Communities & Events
- Confession Feed
- Weekly Challenges
- Follow Groups
- Private Locker
- Theme Selector

See `UI_SCREENS_DESIGN.md` for detailed mockups.

## 🚀 Deployment

### Backend (Supabase)
1. Create Supabase project
2. Run database migrations
3. Configure storage & RLS policies
4. Enable real-time subscriptions

### Frontend (Flutter)

**Android**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
flutter build ipa --release
```

**Web**
```bash
flutter build web --release
```

See `DEPLOYMENT_GUIDE.md` for complete instructions.

## 📊 Performance Optimization

- **Image Compression**: Max 1920px width, 85% quality
- **Video Compression**: 720p for MVP
- **Caching**: Hive for local storage, cached_network_image for images
- **Pagination**: 20 items per page
- **CDN**: Supabase built-in CDN for media

## 🔒 Security

- Row Level Security (RLS) enabled on all tables
- Parameterized queries to prevent SQL injection
- PIN hashing for private locker
- HTTPS only
- Input validation on client and server

## 🌍 Global Support

- No country restrictions
- Multi-language support ready (i18n)
- Global CDN for fast media delivery
- Timezone-aware timestamps

## 📱 Supported Platforms

- ✅ Android (5.0+)
- ✅ iOS (12.0+)
- ✅ Web (Chrome, Safari, Firefox)

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📈 Scalability

### Database
- Indexed frequently queried fields
- Connection pooling
- Pagination for all lists
- Archive old data periodically

### Storage
- CDN caching
- Lazy loading
- Thumbnail generation
- Automatic cleanup

### Real-time
- Selective subscriptions
- Unsubscribe on screen exit
- Debouncing for typing indicators

## 💰 Cost Estimation

### Supabase Free Tier
- 500 MB database
- 1 GB storage
- 2 GB bandwidth
- Good for: Testing, small MVP

### Supabase Pro ($25/month)
- 8 GB database
- 100 GB storage
- 250 GB bandwidth
- Good for: 10k-50k users

## 🤝 Contributing

This is an MVP project. To extend:

1. Fork the repository
2. Create a feature branch
3. Implement your feature
4. Submit a pull request

## 📄 License

This project is provided as-is for educational and commercial use.

## 🆘 Support

For issues and questions:
1. Check `DEPLOYMENT_GUIDE.md`
2. Review `API_ENDPOINTS.md`
3. Check Supabase documentation
4. Review Flutter documentation

## 🎯 Roadmap

### Phase 1 (MVP) - Current
- Core social features
- All unique features listed above

### Phase 2 (Future)
- Push notifications
- Video calls
- Stories (24-hour posts)
- Live streaming
- Advanced analytics
- Monetization features

## 📝 Notes

- **No AI features** - All features are manual/user-driven
- **No paid APIs** - Uses free services (Supabase, OpenStreetMap)
- **Global support** - Works worldwide
- **MVP-level** - Production-ready but can be enhanced

## 🏗️ Built With

- [Flutter](https://flutter.dev/) - UI framework
- [Supabase](https://supabase.com/) - Backend as a Service
- [Provider](https://pub.dev/packages/provider) - State management
- [Hive](https://pub.dev/packages/hive) - Local storage
- [flutter_map](https://pub.dev/packages/flutter_map) - Maps

---

**Ready to launch!** Follow the deployment guide to get your app live. 🚀
