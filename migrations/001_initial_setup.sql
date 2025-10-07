-- Migration 001: Configuration initiale
-- Date: 2025-10-07
-- Description: Création des tables de base pour le service de pensées

-- Table thoughts
CREATE TABLE IF NOT EXISTS thoughts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    content TEXT NOT NULL CHECK (char_length(content) <= 500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    likes_count INTEGER DEFAULT 0,
    CONSTRAINT content_not_empty CHECK (char_length(trim(content)) > 0)
);

CREATE INDEX IF NOT EXISTS idx_thoughts_created_at ON thoughts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_thoughts_username ON thoughts(username);

-- Table thought_likes
CREATE TABLE IF NOT EXISTS thought_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    thought_id UUID NOT NULL REFERENCES thoughts(id) ON DELETE CASCADE,
    user_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_user_thought_like UNIQUE(thought_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_thought_likes_thought_id ON thought_likes(thought_id);
CREATE INDEX IF NOT EXISTS idx_thought_likes_user_id ON thought_likes(user_id);

-- Table users
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    firebase_uid VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(255),
    email VARCHAR(255),
    avatar_url TEXT,
    avatar_id VARCHAR(50),
    expo_token VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_firebase_uid ON users(firebase_uid);
CREATE INDEX IF NOT EXISTS idx_users_expo_token ON users(expo_token) WHERE expo_token IS NOT NULL;
