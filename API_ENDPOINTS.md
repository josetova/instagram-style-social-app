# API Endpoints & Supabase Functions

## Authentication (Supabase Auth)

### Sign Up
```dart
supabase.auth.signUp(email: email, password: password)
```

### Sign In
```dart
supabase.auth.signInWithPassword(email: email, password: password)
```

### Phone Auth
```dart
supabase.auth.signInWithOtp(phone: phone)
```

### Password Reset
```dart
supabase.auth.resetPasswordForEmail(email)
```

## Users

### Get User Profile
```sql
SELECT * FROM users WHERE id = $1
```

### Update User Profile
```sql
UPDATE users SET name = $1, bio = $2, profile_photo_url = $3, custom_status = $4, profile_theme = $5 WHERE id = $6
```

### Update User Location
```sql
UPDATE users SET location = ST_SetSRID(ST_MakePoint($1, $2), 4326) WHERE id = $3
```

### Search Users
```sql
SELECT * FROM users WHERE username ILIKE '%' || $1 || '%' OR name ILIKE '%' || $1 || '%' LIMIT 20
```

## Posts

### Create Post
```sql
INSERT INTO posts (user_id, caption, media_urls, media_type, location_name, location_coords, hashtags, is_draft, time_locked_until, visibility, group_id)
VALUES ($1, $2, $3, $4, $5, ST_SetSRID(ST_MakePoint($6, $7), 4326), $8, $9, $10, $11, $12)
RETURNING *
```

### Get Home Feed (Following)
```sql
SELECT p.*, u.username, u.name, u.profile_photo_url,
  (SELECT COUNT(*) FROM likes WHERE post_id = p.id) as likes_count,
  (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count,
  EXISTS(SELECT 1 FROM likes WHERE post_id = p.id AND user_id = $1) as is_liked
FROM posts p
JOIN follows f ON p.user_id = f.following_id
JOIN users u ON p.user_id = u.id
WHERE f.follower_id = $1 
  AND p.is_draft = FALSE
  AND (p.time_locked_until IS NULL OR p.time_locked_until <= NOW())
ORDER BY p.created_at DESC
LIMIT 20 OFFSET $2
```

### Get Explore Feed (Global)
```sql
SELECT p.*, u.username, u.name, u.profile_photo_url,
  (SELECT COUNT(*) FROM likes WHERE post_id = p.id) as likes_count,
  (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count,
  EXISTS(SELECT 1 FROM likes WHERE post_id = p.id AND user_id = $1) as is_liked
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.is_draft = FALSE
  AND (p.time_locked_until IS NULL OR p.time_locked_until <= NOW())
  AND p.visibility = 'public'
ORDER BY p.created_at DESC
LIMIT 20 OFFSET $2
```

### Get Local Feed (1-3km radius)
```sql
SELECT p.*, u.username, u.name, u.profile_photo_url,
  ST_Distance(p.location_coords::geography, ST_SetSRID(ST_MakePoint($2, $3), 4326)::geography) / 1000 as distance_km,
  (SELECT COUNT(*) FROM likes WHERE post_id = p.id) as likes_count,
  (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.location_coords IS NOT NULL
  AND p.is_draft = FALSE
  AND (p.time_locked_until IS NULL OR p.time_locked_until <= NOW())
  AND ST_DWithin(
    p.location_coords::geography,
    ST_SetSRID(ST_MakePoint($2, $3), 4326)::geography,
    $4 * 1000
  )
ORDER BY p.created_at DESC
LIMIT 20 OFFSET $5
```

### Get User Posts
```sql
SELECT p.*, 
  (SELECT COUNT(*) FROM likes WHERE post_id = p.id) as likes_count,
  (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comments_count
FROM posts p
WHERE p.user_id = $1 AND p.is_draft = FALSE
ORDER BY p.created_at DESC
LIMIT 20 OFFSET $2
```

### Get Saved Posts
```sql
SELECT p.*, u.username, u.name, u.profile_photo_url
FROM posts p
JOIN saved_posts sp ON p.id = sp.post_id
JOIN users u ON p.user_id = u.id
WHERE sp.user_id = $1
ORDER BY sp.created_at DESC
LIMIT 20 OFFSET $2
```

### Get Liked Posts
```sql
SELECT p.*, u.username, u.name, u.profile_photo_url
FROM posts p
JOIN likes l ON p.id = l.post_id
JOIN users u ON p.user_id = u.id
WHERE l.user_id = $1
ORDER BY l.created_at DESC
LIMIT 20 OFFSET $2
```

### Delete Post
```sql
DELETE FROM posts WHERE id = $1 AND user_id = $2
```

## Duet Posts

### Create Duet Post
```sql
-- First create the post
INSERT INTO posts (user_id, caption, media_urls, media_type) VALUES ($1, $2, $3, 'photo') RETURNING id;
-- Then create duet entry
INSERT INTO duet_posts (post_id, user1_id, user2_id, user1_media_url, user2_media_url)
VALUES ($1, $2, $3, $4, $5)
```

## Story Chains

### Create Story Chain
```sql
INSERT INTO story_chains (creator_id, title) VALUES ($1, $2) RETURNING *
```

### Add to Story Chain
```sql
INSERT INTO story_chain_items (chain_id, user_id, media_url, media_type, order_index)
VALUES ($1, $2, $3, $4, (SELECT COALESCE(MAX(order_index), 0) + 1 FROM story_chain_items WHERE chain_id = $1))
```

### Get Story Chain
```sql
SELECT sc.*, u.username, u.profile_photo_url,
  (SELECT json_agg(json_build_object('id', sci.id, 'user_id', sci.user_id, 'media_url', sci.media_url, 'username', u2.username))
   FROM story_chain_items sci
   JOIN users u2 ON sci.user_id = u2.id
   WHERE sci.chain_id = sc.id
   ORDER BY sci.order_index) as items
FROM story_chains sc
JOIN users u ON sc.creator_id = u.id
WHERE sc.id = $1
```

## Reverse Stories

### Create Reverse Story
```sql
INSERT INTO reverse_stories (creator_id, frame_url, title) VALUES ($1, $2, $3) RETURNING *
```

### Add Contribution
```sql
INSERT INTO reverse_story_contributions (reverse_story_id, user_id, media_url) VALUES ($1, $2, $3)
```

## Likes

### Like Post
```sql
INSERT INTO likes (user_id, post_id) VALUES ($1, $2) ON CONFLICT DO NOTHING
```

### Unlike Post
```sql
DELETE FROM likes WHERE user_id = $1 AND post_id = $2
```

## Comments

### Create Comment
```sql
INSERT INTO comments (user_id, post_id, parent_comment_id, content, voice_note_url)
VALUES ($1, $2, $3, $4, $5) RETURNING *
```

### Get Comments
```sql
SELECT c.*, u.username, u.profile_photo_url,
  (SELECT COUNT(*) FROM comments WHERE parent_comment_id = c.id) as replies_count
FROM comments c
JOIN users u ON c.user_id = u.id
WHERE c.post_id = $1 AND c.parent_comment_id IS NULL
ORDER BY c.created_at DESC
LIMIT 20 OFFSET $2
```

### Get Replies
```sql
SELECT c.*, u.username, u.profile_photo_url
FROM comments c
JOIN users u ON c.user_id = u.id
WHERE c.parent_comment_id = $1
ORDER BY c.created_at ASC
```

## Follows

### Follow User
```sql
INSERT INTO follows (follower_id, following_id) VALUES ($1, $2) ON CONFLICT DO NOTHING
```

### Unfollow User
```sql
DELETE FROM follows WHERE follower_id = $1 AND following_id = $2
```

### Get Followers
```sql
SELECT u.* FROM users u
JOIN follows f ON u.id = f.follower_id
WHERE f.following_id = $1
LIMIT 20 OFFSET $2
```

### Get Following
```sql
SELECT u.* FROM users u
JOIN follows f ON u.id = f.following_id
WHERE f.follower_id = $1
LIMIT 20 OFFSET $2
```

### Check if Following
```sql
SELECT EXISTS(SELECT 1 FROM follows WHERE follower_id = $1 AND following_id = $2)
```

## Follow Groups

### Create Follow Group
```sql
INSERT INTO follow_groups (user_id, name) VALUES ($1, $2) RETURNING *
```

### Add Member to Group
```sql
INSERT INTO follow_group_members (group_id, user_id) VALUES ($1, $2) ON CONFLICT DO NOTHING
```

### Get User's Groups
```sql
SELECT fg.*, 
  (SELECT COUNT(*) FROM follow_group_members WHERE group_id = fg.id) as members_count
FROM follow_groups fg
WHERE fg.user_id = $1
```

### Get Group Feed
```sql
SELECT p.*, u.username, u.name, u.profile_photo_url
FROM posts p
JOIN users u ON p.user_id = u.id
WHERE p.group_id = $1 AND p.visibility = 'group'
ORDER BY p.created_at DESC
```

## Friendship Levels

### Get Friendship Level
```sql
SELECT * FROM friendship_levels 
WHERE (user1_id = $1 AND user2_id = $2) OR (user1_id = $2 AND user2_id = $1)
```

### Update Friendship Points (via function)
```sql
SELECT update_friendship_points($1, $2, $3)
```

## Messages

### Create Conversation
```sql
INSERT INTO conversations (is_group, name, emoji_only_mode, auto_delete_after)
VALUES ($1, $2, $3, $4) RETURNING *
```

### Add Participants
```sql
INSERT INTO conversation_participants (conversation_id, user_id) VALUES ($1, $2)
```

### Send Message
```sql
INSERT INTO messages (conversation_id, sender_id, content, media_url, is_emoji_only, delete_at)
VALUES ($1, $2, $3, $4, $5, $6) RETURNING *
```

### Get Conversations
```sql
SELECT c.*, 
  (SELECT json_agg(json_build_object('id', u.id, 'username', u.username, 'profile_photo_url', u.profile_photo_url))
   FROM conversation_participants cp
   JOIN users u ON cp.user_id = u.id
   WHERE cp.conversation_id = c.id AND cp.user_id != $1) as participants,
  (SELECT content FROM messages WHERE conversation_id = c.id ORDER BY created_at DESC LIMIT 1) as last_message
FROM conversations c
JOIN conversation_participants cp ON c.id = cp.conversation_id
WHERE cp.user_id = $1
ORDER BY c.created_at DESC
```

### Get Messages (Real-time)
```sql
SELECT m.*, u.username, u.profile_photo_url
FROM messages m
JOIN users u ON m.sender_id = u.id
WHERE m.conversation_id = $1
  AND (m.delete_at IS NULL OR m.delete_at > NOW())
ORDER BY m.created_at ASC
LIMIT 50 OFFSET $2
```

## Notifications

### Create Notification
```sql
INSERT INTO notifications (user_id, type, actor_id, post_id, comment_id)
VALUES ($1, $2, $3, $4, $5)
```

### Get Notifications
```sql
SELECT n.*, u.username, u.profile_photo_url
FROM notifications n
JOIN users u ON n.actor_id = u.id
WHERE n.user_id = $1
ORDER BY n.created_at DESC
LIMIT 20 OFFSET $2
```

### Mark as Read
```sql
UPDATE notifications SET is_read = TRUE WHERE id = $1
```

### Get Unread Count
```sql
SELECT COUNT(*) FROM notifications WHERE user_id = $1 AND is_read = FALSE
```

## Communities

### Create Community
```sql
INSERT INTO communities (name, type, description, location)
VALUES ($1, $2, $3, ST_SetSRID(ST_MakePoint($4, $5), 4326)) RETURNING *
```

### Join Community
```sql
INSERT INTO community_members (community_id, user_id) VALUES ($1, $2) ON CONFLICT DO NOTHING
```

### Get User Communities
```sql
SELECT c.* FROM communities c
JOIN community_members cm ON c.id = cm.community_id
WHERE cm.user_id = $1
```

### Get Community Feed
```sql
SELECT p.*, u.username, u.name, u.profile_photo_url
FROM posts p
JOIN users u ON p.user_id = u.id
JOIN community_members cm ON u.id = cm.user_id
WHERE cm.community_id = $1
ORDER BY p.created_at DESC
LIMIT 20 OFFSET $2
```

## Events

### Create Event
```sql
INSERT INTO events (creator_id, community_id, title, description, location_name, location_coords, event_date)
VALUES ($1, $2, $3, $4, $5, ST_SetSRID(ST_MakePoint($6, $7), 4326), $8) RETURNING *
```

### Get Nearby Events
```sql
SELECT e.*, u.username,
  ST_Distance(e.location_coords::geography, ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography) / 1000 as distance_km,
  (SELECT COUNT(*) FROM event_attendees WHERE event_id = e.id AND status = 'going') as attendees_count
FROM events e
JOIN users u ON e.creator_id = u.id
WHERE ST_DWithin(
  e.location_coords::geography,
  ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography,
  $3 * 1000
)
ORDER BY e.event_date ASC
```

### RSVP to Event
```sql
INSERT INTO event_attendees (event_id, user_id, status)
VALUES ($1, $2, $3)
ON CONFLICT (event_id, user_id) DO UPDATE SET status = $3
```

## Confessions

### Create Confession
```sql
INSERT INTO confessions (content) VALUES ($1) RETURNING *
```

### Get Confessions Feed
```sql
SELECT c.*,
  (SELECT COUNT(*) FROM confession_votes WHERE confession_id = c.id AND vote_type = 'upvote') as upvotes,
  (SELECT COUNT(*) FROM confession_votes WHERE confession_id = c.id AND vote_type = 'downvote') as downvotes
FROM confessions c
WHERE c.is_approved = TRUE
ORDER BY c.created_at DESC
LIMIT 20 OFFSET $1
```

### Vote on Confession
```sql
INSERT INTO confession_votes (confession_id, user_id, vote_type)
VALUES ($1, $2, $3)
ON CONFLICT (confession_id, user_id) DO UPDATE SET vote_type = $3
```

## Challenges

### Create Challenge
```sql
INSERT INTO challenges (title, description, category, start_date, end_date)
VALUES ($1, $2, $3, $4, $5) RETURNING *
```

### Submit to Challenge
```sql
INSERT INTO challenge_submissions (challenge_id, user_id, post_id)
VALUES ($1, $2, $3) RETURNING *
```

### Vote on Submission
```sql
INSERT INTO challenge_votes (submission_id, user_id) VALUES ($1, $2) ON CONFLICT DO NOTHING;
UPDATE challenge_submissions SET votes_count = votes_count + 1 WHERE id = $1
```

### Get Active Challenges
```sql
SELECT * FROM challenges
WHERE start_date <= NOW() AND end_date >= NOW()
ORDER BY start_date DESC
```

### Get Challenge Submissions
```sql
SELECT cs.*, p.*, u.username, u.profile_photo_url
FROM challenge_submissions cs
JOIN posts p ON cs.post_id = p.id
JOIN users u ON cs.user_id = u.id
WHERE cs.challenge_id = $1
ORDER BY cs.votes_count DESC
LIMIT 20 OFFSET $2
```

## Private Locker

### Add to Locker
```sql
INSERT INTO locker_posts (user_id, post_id, pin_hash) VALUES ($1, $2, $3)
```

### Get Locker Posts (after PIN verification)
```sql
SELECT p.* FROM posts p
JOIN locker_posts lp ON p.id = lp.post_id
WHERE lp.user_id = $1 AND lp.pin_hash = $2
```

## Storage Operations (Supabase Storage)

### Upload Media
```dart
final file = File(path);
final fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(path)}';
await supabase.storage.from('media').upload('posts/$fileName', file);
final url = supabase.storage.from('media').getPublicUrl('posts/$fileName');
```

### Upload Profile Photo
```dart
await supabase.storage.from('avatars').upload('$userId.jpg', file);
```

## Real-time Subscriptions

### Subscribe to Messages
```dart
supabase
  .from('messages')
  .stream(primaryKey: ['id'])
  .eq('conversation_id', conversationId)
  .listen((data) {
    // Handle new messages
  });
```

### Subscribe to Notifications
```dart
supabase
  .from('notifications')
  .stream(primaryKey: ['id'])
  .eq('user_id', userId)
  .listen((data) {
    // Handle new notifications
  });
```
