# Deployment Guide - Instagram-Style Social Media App

## Prerequisites

- Flutter SDK (latest stable)
- Supabase account
- Google Play Console account (for Android)
- Apple Developer account (for iOS)
- Git

## Backend Deployment (Supabase)

### Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Click "New Project"
3. Fill in project details:
   - Name: social-media-app
   - Database Password: (generate strong password)
   - Region: Choose closest to your target users
4. Wait for project to be created (~2 minutes)

### Step 2: Set Up Database

1. Go to SQL Editor in Supabase dashboard
2. Copy contents of `DATABASE_SCHEMA.sql`
3. Paste and run the SQL script
4. Verify all tables are created in Table Editor

### Step 3: Configure Storage Buckets

```sql
-- Create storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES 
  ('avatars', 'avatars', true),
  ('media', 'media', true),
  ('voice-notes', 'voice-notes', true);

-- Set up storage policies
CREATE POLICY "Avatar images are publicly accessible"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload their own avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Media is publicly accessible"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'media');

CREATE POLICY "Authenticated users can upload media"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'media' AND auth.role() = 'authenticated');
```

### Step 4: Enable Row Level Security (RLS)

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
-- ... (enable for all tables)

-- Example policies
CREATE POLICY "Users can view all profiles"
  ON users FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Public posts are viewable by everyone"
  ON posts FOR SELECT
  USING (visibility = 'public' OR user_id = auth.uid());

CREATE POLICY "Users can create their own posts"
  ON posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own posts"
  ON posts FOR DELETE
  USING (auth.uid() = user_id);
```

### Step 5: Configure Authentication

1. Go to Authentication → Settings
2. Enable Email provider
3. Enable Phone provider (optional, requires Twilio)
4. Configure email templates
5. Set Site URL to your app's URL

### Step 6: Enable Real-time

1. Go to Database → Replication
2. Enable real-time for tables:
   - messages
   - notifications
   - likes
   - comments

### Step 7: Get API Keys

1. Go to Settings → API
2. Copy:
   - Project URL
   - Anon/Public key
3. Update `lib/main.dart` with these values

## Frontend Deployment (Flutter)

### Step 1: Configure Flutter Project

1. Update `pubspec.yaml` with all dependencies
2. Run `flutter pub get`
3. Update Supabase credentials in `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### Step 2: Configure App Icons & Splash Screen

```bash
# Add flutter_launcher_icons to dev_dependencies
flutter pub add dev:flutter_launcher_icons

# Add configuration to pubspec.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/logo.png"

# Generate icons
flutter pub run flutter_launcher_icons
```

### Step 3: Android Deployment

#### Configure Android App

1. Update `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.socialmediaapp"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

2. Update `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
</manifest>
```

#### Build APK

```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### Upload to Google Play Store

1. Create app in Google Play Console
2. Fill in app details, screenshots, description
3. Upload AAB file from `build/app/outputs/bundle/release/`
4. Complete content rating questionnaire
5. Set pricing (free)
6. Submit for review

### Step 4: iOS Deployment

#### Configure iOS App

1. Open `ios/Runner.xcworkspace` in Xcode
2. Update Bundle Identifier
3. Select Development Team
4. Update `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for voice notes</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need location to show nearby posts</string>
```

#### Build IPA

```bash
# Build iOS release
flutter build ios --release

# Or build IPA for distribution
flutter build ipa --release
```

#### Upload to App Store

1. Open Xcode
2. Product → Archive
3. Distribute App → App Store Connect
4. Upload to App Store Connect
5. Complete app information in App Store Connect
6. Submit for review

### Step 5: Web Deployment (Optional)

```bash
# Build web version
flutter build web --release

# Deploy to Vercel
npm i -g vercel
cd build/web
vercel --prod

# Or deploy to Netlify
# Drag and drop build/web folder to Netlify
```

## Environment Configuration

### Development

```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String supabaseUrl = 'YOUR_DEV_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_DEV_ANON_KEY';
  static const bool isProduction = false;
}
```

### Production

```dart
class AppConstants {
  static const String supabaseUrl = 'YOUR_PROD_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_PROD_ANON_KEY';
  static const bool isProduction = true;
}
```

## Performance Optimization

### Image Compression

```dart
// Compress images before upload
import 'package:image_compression_flutter/image_compression_flutter.dart';

Future<File> compressImage(File file) async {
  final input = ImageFile(
    rawBytes: await file.readAsBytes(),
    filePath: file.path,
  );
  
  final output = await compressInQueue(
    ImageFileConfiguration(
      input: input,
      config: Configuration(
        outputType: ImageOutputType.jpg,
        quality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      ),
    ),
  );
  
  return File(output.filePath);
}
```

### Video Compression

```dart
import 'package:video_compress/video_compress.dart';

Future<MediaInfo?> compressVideo(File file) async {
  return await VideoCompress.compressVideo(
    file.path,
    quality: VideoQuality.MediumQuality,
    deleteOrigin: false,
  );
}
```

### Caching Strategy

```dart
// Use Hive for local caching
final box = Hive.box('cache');

// Cache feed data
box.put('home_feed', jsonEncode(posts));

// Retrieve cached data
final cachedData = box.get('home_feed');
```

## Monitoring & Analytics

### Supabase Dashboard

- Monitor database performance
- Check storage usage
- View real-time connections
- Analyze query performance

### Error Tracking

```dart
// Add Sentry for error tracking
import 'package:sentry_flutter/sentry_flutter.dart';

await SentryFlutter.init(
  (options) {
    options.dsn = 'YOUR_SENTRY_DSN';
  },
  appRunner: () => runApp(MyApp()),
);
```

## Scaling Considerations

### Database

- Add indexes for frequently queried fields
- Use connection pooling
- Implement pagination (20-50 items per page)
- Archive old data periodically

### Storage

- Use CDN (Supabase has built-in CDN)
- Implement lazy loading for images
- Use thumbnails for grid views
- Set up automatic cleanup for deleted content

### Real-time

- Limit active subscriptions
- Unsubscribe when leaving screens
- Use debouncing for typing indicators
- Batch notifications

## Security Checklist

- ✅ Enable RLS on all tables
- ✅ Validate user input on client and server
- ✅ Use parameterized queries
- ✅ Implement rate limiting
- ✅ Sanitize user-generated content
- ✅ Use HTTPS only
- ✅ Implement proper authentication
- ✅ Hash sensitive data (PINs, passwords)
- ✅ Regular security audits

## Backup Strategy

### Database Backups

1. Enable automatic backups in Supabase (Pro plan)
2. Or set up manual backups:

```bash
# Export database
pg_dump -h db.xxx.supabase.co -U postgres -d postgres > backup.sql

# Restore database
psql -h db.xxx.supabase.co -U postgres -d postgres < backup.sql
```

### Storage Backups

- Supabase handles storage redundancy
- Consider periodic exports for critical media

## Cost Estimation (Supabase)

### Free Tier
- 500 MB database
- 1 GB storage
- 2 GB bandwidth
- Good for: Testing, small MVP

### Pro Tier ($25/month)
- 8 GB database
- 100 GB storage
- 250 GB bandwidth
- Good for: 10k-50k users

### Scaling
- Add compute for $0.01344/hour
- Add storage for $0.125/GB/month
- Add bandwidth for $0.09/GB

## Launch Checklist

- [ ] Database schema deployed
- [ ] Storage buckets configured
- [ ] RLS policies enabled
- [ ] Authentication configured
- [ ] Real-time enabled
- [ ] API keys updated in app
- [ ] App icons generated
- [ ] Splash screen configured
- [ ] Permissions configured
- [ ] Build signed APK/IPA
- [ ] Test on real devices
- [ ] Submit to app stores
- [ ] Set up monitoring
- [ ] Prepare support documentation
- [ ] Create privacy policy
- [ ] Create terms of service

## Post-Launch

1. Monitor crash reports
2. Track user feedback
3. Analyze usage metrics
4. Plan feature updates
5. Regular security updates
6. Database maintenance
7. Performance optimization
