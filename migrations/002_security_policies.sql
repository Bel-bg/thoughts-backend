-- Migration 002: Politiques de sécurité (RLS)
-- Date: 2025-10-07
-- Description: Configuration de Row Level Security pour toutes les tables

-- Activer RLS sur thoughts
ALTER TABLE thoughts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Tout le monde peut lire les pensées" ON thoughts;
CREATE POLICY "Tout le monde peut lire les pensées"
    ON thoughts FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Utilisateurs authentifiés peuvent créer" ON thoughts;
CREATE POLICY "Utilisateurs authentifiés peuvent créer"
    ON thoughts FOR INSERT
    WITH CHECK (true);

DROP POLICY IF EXISTS "Système peut supprimer les pensées expirées" ON thoughts;
CREATE POLICY "Système peut supprimer les pensées expirées"
    ON thoughts FOR DELETE
    USING (created_at < NOW() - INTERVAL '24 hours');

-- Activer RLS sur thought_likes
ALTER TABLE thought_likes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Tout le monde peut lire les likes" ON thought_likes;
CREATE POLICY "Tout le monde peut lire les likes"
    ON thought_likes FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Utilisateurs peuvent liker" ON thought_likes;
CREATE POLICY "Utilisateurs peuvent liker"
    ON thought_likes FOR INSERT
    WITH CHECK (true);

DROP POLICY IF EXISTS "Utilisateurs peuvent supprimer leurs likes" ON thought_likes;
CREATE POLICY "Utilisateurs peuvent supprimer leurs likes"
    ON thought_likes FOR DELETE
    USING (true);

-- Activer RLS sur users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Lecture publique des profils" ON users;
CREATE POLICY "Lecture publique des profils"
    ON users FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Utilisateurs peuvent modifier leur profil" ON users;
CREATE POLICY "Utilisateurs peuvent modifier leur profil"
    ON users FOR UPDATE
    USING (true);

DROP POLICY IF EXISTS "Création de nouveaux utilisateurs" ON users;
CREATE POLICY "Création de nouveaux utilisateurs"
    ON users FOR INSERT
    WITH CHECK (true);
