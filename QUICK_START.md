# Quick Start Guide

Get your Instagram-style social media app running in 30 minutes!

## Prerequisites

- Flutter SDK installed ([flutter.dev](https://flutter.dev))
- Code editor (VS Code or Android Studio)
- Supabase account ([supabase.com](https://supabase.com))

## Step 1: Create Supabase Project (5 minutes)

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Fill in:
   - **Name**: social-media-app
   - **Database Password**: (generate and save it)
   - **Region**: Choose closest to you
4. Click "Create new project"
5. Wait ~2 minutes for setup

## Step 2: Set Up Database (5 minutes)

1. In Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy entire contents of `DATABASE_SCHEMA.sql`
4. Paste into SQL Editor
5. Click "Run" (bottom right)
6. Verify: Go to **Table Editor** - you should see all tables

## Step 3: Configure Storage (3 minutes)

1. Go to **Storage** in Supabase dashboard
2. Click "Create bucket"
3. Create three buckets:
   - Name: `avatars`, Public: ✅
   - Name: `media`, Public: ✅
   - Name: `voice-notes`, Public: ✅

## Step 4: Enable Real-time (2 minutes)

1. Go to **Database** → **Replication**
2. Enable real-time for these tables:
   - messages
   - notifications
   - likes
   - comments

## Step 5: Get API Keys (1 minute)

1. Go to **Settings** → **API**
2. Copy these values:
   - **Project URL**: `https://xxx.supabase.co`
   - **anon/public key**: `eyJhbG...`

## Step 6: Set Up Flutter Project (5 minutes)

```bash
# Clone or create project directory
mkdir social_media_app
cd social_media_app

# Copy all files from this repository

# Install dependencies
flutter pub get
```

## Step 7: Configure App (2 minutes)

Open `lib/main.dart` and update:

```dart
await Supabase.initialize(
  url: 'YOUR_PROJECT_URL_HERE',        // From Step 5
  anonKey: 'YOUR_ANON_KEY_HERE',       // From Step 5
);
```

## Step 8: Run the App (2 minutes)

```bash
# Connect your device or start emulator

# Run app
flutter run
```

## Step 9: Test Basic Features (5 minutes)

1. **Sign Up**
   - Open app
   - Click "Sign Up"
   - Enter: email, username, name, password
   - Click "Sign Up"

2. **Create Post**
   - Click "+" tab
   - Select photo
   - Add caption
   - Click "Post"

3. **View Feed**
   - Go to Home tab
   - See your post

## Troubleshooting

### "Connection refused" error
- Check your internet connection
- Verify Supabase URL and key are correct
- Make sure Supabase project is active

### "Table does not exist" error
- Go back to Step 2
- Make sure DATABASE_SCHEMA.sql ran successfully
- Check Table Editor to verify tables exist

### "Storage bucket not found" error
- Go back to Step 3
- Verify all three buckets are created
- Make sure they're set to "Public"

### App crashes on startup
```bash
# Clear cache and rebuild
flutter clean
flutter pub get
flutter run
```

## Next Steps

### Add Test Data

Create some test posts to see the feed in action:

```sql
-- In Supabase SQL Editor
INSERT INTO posts (user_id, caption, media_urls, media_type)
VALUES (
  (SELECT id FROM users LIMIT 1),
  'My first post! #hello',
  ARRAY['https://picsum.photos/800/600'],
  'photo'
);
```

### Customize Branding

1. Replace `assets/images/logo.png` with your logo
2. Update colors in `lib/core/constants/app_colors.dart`
3. Update app name in `pubspec.yaml`

### Enable Additional Features

#### Location Features
```bash
# Add permissions to AndroidManifest.xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

#### Camera Access
```bash
# Add permissions to AndroidManifest.xml
<uses-permission android:name="android.permission.CAMERA"/>
```

#### Voice Notes
```bash
# Add permissions to AndroidManifest.xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

### Test Unique Features

1. **Local Feed**
   - Enable location permissions
   - Create posts with location
   - View Local Feed tab

2. **Story Chains**
   - Create a story chain
   - Add photos to it
   - Invite friends to contribute

3. **Duet Posts**
   - Create a duet post
   - Invite another user
   - See split-screen result

4. **Emoji-Only Chat**
   - Start a conversation
   - Enable emoji-only mode
   - Send emoji messages

5. **Profile Themes**
   - Go to Profile → Settings
   - Select different themes
   - See profile change colors

## Production Checklist

Before deploying to production:

- [ ] Update Supabase URL and keys
- [ ] Enable Row Level Security (RLS) policies
- [ ] Set up proper authentication
- [ ] Configure storage policies
- [ ] Add error tracking (Sentry)
- [ ] Test on real devices
- [ ] Create privacy policy
- [ ] Create terms of service
- [ ] Set up app icons
- [ ] Configure splash screen
- [ ] Test all features
- [ ] Optimize images
- [ ] Enable caching

## Getting Help

1. **Documentation**
   - Read `README.md` for overview
   - Check `DEPLOYMENT_GUIDE.md` for detailed setup
   - Review `API_ENDPOINTS.md` for API usage
   - See `IMPLEMENTATION_EXAMPLES.md` for code samples

2. **Common Issues**
   - Check Supabase dashboard for errors
   - Review Flutter console for logs
   - Verify database tables exist
   - Confirm storage buckets are public

3. **Resources**
   - [Flutter Documentation](https://flutter.dev/docs)
   - [Supabase Documentation](https://supabase.com/docs)
   - [Provider Documentation](https://pub.dev/packages/provider)

## Development Tips

### Hot Reload
```bash
# Press 'r' in terminal for hot reload
# Press 'R' for hot restart
```

### Debug Mode
```bash
# Run with verbose logging
flutter run -v
```

### Check Diagnostics
```bash
# Verify Flutter setup
flutter doctor
```

### View Logs
```bash
# Android
flutter logs

# iOS
flutter logs
```

## What's Next?

1. **Customize UI**: Update colors, fonts, and layouts
2. **Add Features**: Implement additional unique features
3. **Test Thoroughly**: Test on multiple devices
4. **Optimize Performance**: Add caching and compression
5. **Deploy**: Follow `DEPLOYMENT_GUIDE.md` to publish

## Success! 🎉

You now have a fully functional social media app with:
- ✅ User authentication
- ✅ Post creation and feeds
- ✅ Social interactions
- ✅ Messaging
- ✅ 50+ unique features
- ✅ Real-time updates
- ✅ Global scalability

Start customizing and building your community!

---

**Estimated Setup Time**: 30 minutes
**Difficulty**: Beginner-friendly
**Support**: Check documentation files for detailed help
