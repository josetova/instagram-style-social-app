-- Instagram-Style Social Media App - Complete Database Schema
-- Supabase PostgreSQL

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================
-- USERS & AUTHENTICATION
-- ============================================

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE,
  phone TEXT UNIQUE,
  username TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  bio TEXT,
  profile_photo_url TEXT,
  custom_status TEXT,
  profile_theme TEXT DEFAULT 'minimal', -- minimal, neon, dark, pastel, sunset
  location GEOGRAPHY(POINT),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_location ON users USING GIST(location);

-- ============================================
-- POSTS
-- ============================================

CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  caption TEXT,
  media_urls TEXT[], -- array of image/video URLs
  media_type TEXT NOT NULL, -- 'photo', 'video'
  location_name TEXT,
  location_coords GEOGRAPHY(POINT),
  hashtags TEXT[],
  is_draft BOOLEAN DEFAULT FALSE,
  time_locked_until TIMESTAMP WITH TIME ZONE, -- for time-locked posts
  visibility TEXT DEFAULT 'public', -- public, friends, group
  group_id UUID, -- for follow groups
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX idx_posts_location ON posts USING GIST(location_coords);
CREATE INDEX idx_posts_hashtags ON posts USING GIN(hashtags);
CREATE INDEX idx_posts_time_locked ON posts(time_locked_until) WHERE time_locked_until IS NOT NULL;

-- ============================================
-- DUET POSTS (Split Grid Posts)
-- ============================================

CREATE TABLE duet_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  user1_id UUID REFERENCES users(id) ON DELETE CASCADE,
  user2_id UUID REFERENCES users(id) ON DELETE CASCADE,
  user1_media_url TEXT,
  user2_media_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_duet_posts_post_id ON duet_posts(post_id);

-- ============================================
-- STORY CHAINS
-- ============================================

CREATE TABLE story_chains (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  creator_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() + INTERVAL '24 hours',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE story_chain_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  chain_id UUID REFERENCES story_chains(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  media_url TEXT NOT NULL,
  media_type TEXT NOT NULL,
  order_index INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_story_chains_creator ON story_chains(creator_id);
CREATE INDEX idx_story_chain_items_chain ON story_chain_items(chain_id, order_index);

-- ============================================
-- REVERSE STORIES
-- ============================================

CREATE TABLE reverse_stories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  creator_id UUID REFERENCES users(id) ON DELETE CASCADE,
  frame_url TEXT NOT NULL, -- the frame/template
  title TEXT,
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() + INTERVAL '24 hours',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE reverse_story_contributions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reverse_story_id UUID REFERENCES reverse_stories(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  media_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- REPOST TEMPLATES
-- ============================================

CREATE TABLE reposts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  original_post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  template_type TEXT NOT NULL, -- polaroid, meme, collage, moodboard
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_reposts_user ON reposts(user_id);
CREATE INDEX idx_reposts_original ON reposts(original_post_id);

-- ============================================
-- LIKES
-- ============================================

CREATE TABLE likes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_likes_post ON likes(post_id);
CREATE INDEX idx_likes_user ON likes(user_id);

-- ============================================
-- COMMENTS
-- ============================================

CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT,
  voice_note_url TEXT, -- for voice note comments
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_comments_post ON comments(post_id);
CREATE INDEX idx_comments_user ON comments(user_id);
CREATE INDEX idx_comments_parent ON comments(parent_comment_id);

-- ============================================
-- FOLLOWS
-- ============================================

CREATE TABLE follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(follower_id, following_id)
);

CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);

-- ============================================
-- FOLLOW GROUPS
-- ============================================

CREATE TABLE follow_groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL, -- "Best friends", "College friends", etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE follow_group_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID REFERENCES follow_groups(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(group_id, user_id)
);

CREATE INDEX idx_follow_groups_user ON follow_groups(user_id);
CREATE INDEX idx_follow_group_members_group ON follow_group_members(group_id);

-- ============================================
-- FRIENDSHIP LEVELS
-- ============================================

CREATE TABLE friendship_levels (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user1_id UUID REFERENCES users(id) ON DELETE CASCADE,
  user2_id UUID REFERENCES users(id) ON DELETE CASCADE,
  level TEXT DEFAULT 'bronze', -- bronze, silver, gold, platinum
  points INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user1_id, user2_id)
);

CREATE INDEX idx_friendship_levels_users ON friendship_levels(user1_id, user2_id);

-- ============================================
-- SAVED POSTS
-- ============================================

CREATE TABLE saved_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_saved_posts_user ON saved_posts(user_id);

-- ============================================
-- PRIVATE LOCKER
-- ============================================

CREATE TABLE locker_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  pin_hash TEXT NOT NULL, -- hashed PIN
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_locker_posts_user ON locker_posts(user_id);

-- ============================================
-- MESSAGES & DMs
-- ============================================

CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  is_group BOOLEAN DEFAULT FALSE,
  name TEXT,
  emoji_only_mode BOOLEAN DEFAULT FALSE,
  auto_delete_after INTERVAL, -- 1 hour, 24 hours, 1 week
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE conversation_participants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(conversation_id, user_id)
);

CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT,
  media_url TEXT,
  is_emoji_only BOOLEAN DEFAULT FALSE,
  delete_at TIMESTAMP WITH TIME ZONE, -- for auto-delete
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at DESC);
CREATE INDEX idx_conversation_participants ON conversation_participants(conversation_id);

-- ============================================
-- NOTIFICATIONS
-- ============================================

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- like, comment, follow, message
  actor_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = FALSE;

-- ============================================
-- COMMUNITIES
-- ============================================

CREATE TABLE communities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  type TEXT NOT NULL, -- college, city, workplace
  description TEXT,
  location GEOGRAPHY(POINT),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE community_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  community_id UUID REFERENCES communities(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(community_id, user_id)
);

CREATE INDEX idx_communities_type ON communities(type);
CREATE INDEX idx_community_members_community ON community_members(community_id);
CREATE INDEX idx_community_members_user ON community_members(user_id);

-- ============================================
-- EVENTS
-- ============================================

CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  creator_id UUID REFERENCES users(id) ON DELETE CASCADE,
  community_id UUID REFERENCES communities(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  description TEXT,
  location_name TEXT,
  location_coords GEOGRAPHY(POINT),
  event_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_events_location ON events USING GIST(location_coords);
CREATE INDEX idx_events_date ON events(event_date);

CREATE TABLE event_attendees (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID REFERENCES events(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'going', -- going, interested, not_going
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(event_id, user_id)
);

-- ============================================
-- ANONYMOUS CONFESSIONS
-- ============================================

CREATE TABLE confessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  content TEXT NOT NULL,
  is_moderated BOOLEAN DEFAULT FALSE,
  is_approved BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE confession_votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  confession_id UUID REFERENCES confessions(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  vote_type TEXT, -- upvote, downvote
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(confession_id, user_id)
);

CREATE INDEX idx_confessions_created ON confessions(created_at DESC);

-- ============================================
-- WEEKLY CHALLENGES
-- ============================================

CREATE TABLE challenges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  category TEXT, -- room_setup, photography, fit_check
  start_date TIMESTAMP WITH TIME ZONE,
  end_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE challenge_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  votes_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(challenge_id, user_id)
);

CREATE TABLE challenge_votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  submission_id UUID REFERENCES challenge_submissions(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(submission_id, user_id)
);

CREATE INDEX idx_challenges_dates ON challenges(start_date, end_date);
CREATE INDEX idx_challenge_submissions_challenge ON challenge_submissions(challenge_id);

-- ============================================
-- STORY REACTIONS
-- ============================================

CREATE TABLE story_reactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  story_id UUID, -- references story (not created yet, but for stories feature)
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  reaction_emoji TEXT NOT NULL,
  position_x FLOAT, -- x position on story
  position_y FLOAT, -- y position on story
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON posts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to calculate distance between two points
CREATE OR REPLACE FUNCTION get_nearby_posts(
  user_lat FLOAT,
  user_lng FLOAT,
  radius_km FLOAT DEFAULT 3
)
RETURNS TABLE (
  post_id UUID,
  distance_km FLOAT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    ST_Distance(
      p.location_coords::geography,
      ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography
    ) / 1000 AS distance_km
  FROM posts p
  WHERE p.location_coords IS NOT NULL
    AND ST_DWithin(
      p.location_coords::geography,
      ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography,
      radius_km * 1000
    )
  ORDER BY distance_km;
END;
$$ LANGUAGE plpgsql;

-- Function to update friendship points
CREATE OR REPLACE FUNCTION update_friendship_points(
  uid1 UUID,
  uid2 UUID,
  points_to_add INTEGER
)
RETURNS VOID AS $$
DECLARE
  current_points INTEGER;
  new_level TEXT;
BEGIN
  -- Ensure user1_id < user2_id for consistency
  IF uid1 > uid2 THEN
    uid1 := uid2;
    uid2 := uid1;
  END IF;

  -- Insert or update friendship level
  INSERT INTO friendship_levels (user1_id, user2_id, points)
  VALUES (uid1, uid2, points_to_add)
  ON CONFLICT (user1_id, user2_id)
  DO UPDATE SET 
    points = friendship_levels.points + points_to_add,
    updated_at = NOW();

  -- Get current points
  SELECT points INTO current_points
  FROM friendship_levels
  WHERE user1_id = uid1 AND user2_id = uid2;

  -- Determine level
  IF current_points >= 1000 THEN
    new_level := 'platinum';
  ELSIF current_points >= 500 THEN
    new_level := 'gold';
  ELSIF current_points >= 200 THEN
    new_level := 'silver';
  ELSE
    new_level := 'bronze';
  END IF;

  -- Update level
  UPDATE friendship_levels
  SET level = new_level
  WHERE user1_id = uid1 AND user2_id = uid2;
END;
$$ LANGUAGE plpgsql;
