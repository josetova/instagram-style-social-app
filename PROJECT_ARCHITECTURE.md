# Instagram-Style Social Media App - Complete Architecture

## Tech Stack
- **Frontend**: Flutter (iOS, Android, Web)
- **Backend**: Supabase (PostgreSQL + Real-time + Storage + Auth)
- **Storage**: Supabase Storage with CDN
- **Real-time**: Supabase Real-time subscriptions
- **Maps**: flutter_map + OpenStreetMap (free)

## Core Features Overview

### 1. Authentication
- Email & phone login
- Username, name, bio, profile photo
- Password reset
- Global users (no restrictions)

### 2. Posting
- Photo & video upload
- Captions + hashtags
- Location tags
- Drafts (offline mode)

### 3. Social Features
- Like, comment, follow/unfollow
- DM system (text + emojis)
- Notifications
- Home feed & Explore feed

### 4. Unique Features

#### A. Local & Community
- Local feed (1-3km radius)
- Communities (College/City/Workplace)
- Nearby events feed

#### B. Posting Features
- Time-locked posts
- Story chains
- Reverse stories
- Repost templates (Polaroid, Meme, Collage, Mood-board)

#### C. Interaction Features
- Duet posts (split grid)
- Voice note comments
- Emoji-only DM mode
- Friendship level system (Bronze → Platinum)
- Follow groups

#### D. Anonymous & Fun
- Anonymous confession feed
- Weekly post challenges
- Swipe-mode feed (Tinder-style)

#### E. Personalization
- Profile themes (Minimal, Neon, Dark, Pastel, Sunset)
- Custom status
- Private photo locker (PIN-protected)

#### F. Small Useful Features
- Story reactions as stickers
- Limited-time chats
- Offline drafts

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter Mobile App                      │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │  Auth    │  Feed    │  Post    │  Profile │  Chat    │  │
│  │  Screen  │  Screen  │  Screen  │  Screen  │  Screen  │  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
│                            │                                 │
│                    ┌───────┴───────┐                        │
│                    │  State Mgmt   │                        │
│                    │  (Provider)   │                        │
│                    └───────┬───────┘                        │
└────────────────────────────┼─────────────────────────────────┘
                             │
                    ┌────────┴────────┐
                    │  Supabase SDK   │
                    └────────┬────────┘
                             │
┌────────────────────────────┼─────────────────────────────────┐
│                      Supabase Backend                         │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │   Auth   │   DB     │ Storage  │ Real-time│ Functions│  │
│  │          │(Postgres)│   CDN    │  Subs    │   Edge   │  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
└───────────────────────────────────────────────────────────────┘
```

## Deployment Strategy

### Backend (Supabase)
1. Create Supabase project
2. Run database migrations
3. Configure storage buckets
4. Set up Row Level Security (RLS)
5. Deploy edge functions

### Frontend (Flutter)
1. **Android**: Build APK/AAB → Google Play Store
2. **iOS**: Build IPA → Apple App Store
3. **Web**: Build web → Vercel/Netlify

## Scalability & Optimization

### Database
- Indexes on frequently queried fields
- Pagination (20 items per page)
- Connection pooling

### Storage
- Image compression (max 1920px width)
- Video compression (max 720p for MVP)
- CDN caching (Supabase built-in)

### Real-time
- Selective subscriptions (only active chats)
- Debouncing for typing indicators

### Caching
- Local cache for feeds (Hive)
- Image caching (cached_network_image)
- Offline-first for drafts
