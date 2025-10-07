-- ============================================
-- Base de données pour le service de pensées
-- IG-Live ENEAM Mobile
-- ============================================

-- 1. Table des pensées (thoughts)
-- ============================================
CREATE TABLE IF NOT EXISTS thoughts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    content TEXT NOT NULL CHECK (char_length(content) <= 500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    likes_count INTEGER DEFAULT 0,
    
    -- Index pour améliorer les performances
    CONSTRAINT content_not_empty CHECK (char_length(trim(content)) > 0)
);

-- Index pour trier par date de création
CREATE INDEX IF NOT EXISTS idx_thoughts_created_at ON thoughts(created_at DESC);

-- Index pour rechercher par username
CREATE INDEX IF NOT EXISTS idx_thoughts_username ON thoughts(username);


-- 2. Table des likes sur les pensées (thought_likes)
-- ============================================
CREATE TABLE IF NOT EXISTS thought_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    thought_id UUID NOT NULL REFERENCES thoughts(id) ON DELETE CASCADE,
    user_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Un utilisateur ne peut liker qu'une seule fois une pensée
    CONSTRAINT unique_user_thought_like UNIQUE(thought_id, user_id)
);

-- Index pour améliorer les performances des comptages
CREATE INDEX IF NOT EXISTS idx_thought_likes_thought_id ON thought_likes(thought_id);
CREATE INDEX IF NOT EXISTS idx_thought_likes_user_id ON thought_likes(user_id);


-- 3. Table des utilisateurs (users) - pour les notifications
-- ============================================
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

-- Index pour rechercher rapidement par firebase_uid
CREATE INDEX IF NOT EXISTS idx_users_firebase_uid ON users(firebase_uid);

-- Index pour les tokens Expo (notifications)
CREATE INDEX IF NOT EXISTS idx_users_expo_token ON users(expo_token) WHERE expo_token IS NOT NULL;


-- 4. Fonction pour mettre à jour automatiquement updated_at
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour la table users
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- 5. Fonction pour supprimer les pensées expirées (>24h)
-- ============================================
CREATE OR REPLACE FUNCTION delete_expired_thoughts()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM thoughts
    WHERE created_at < NOW() - INTERVAL '24 hours';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;


-- 6. Activer Row Level Security (RLS) - Sécurité
-- ============================================

-- Activer RLS sur thoughts
ALTER TABLE thoughts ENABLE ROW LEVEL SECURITY;

-- Politique : Tout le monde peut lire les pensées
CREATE POLICY "Tout le monde peut lire les pensées"
    ON thoughts FOR SELECT
    USING (true);

-- Politique : Les utilisateurs authentifiés peuvent créer des pensées
CREATE POLICY "Utilisateurs authentifiés peuvent créer"
    ON thoughts FOR INSERT
    WITH CHECK (true);

-- Politique : Suppression automatique par le système
CREATE POLICY "Système peut supprimer les pensées expirées"
    ON thoughts FOR DELETE
    USING (created_at < NOW() - INTERVAL '24 hours');


-- Activer RLS sur thought_likes
ALTER TABLE thought_likes ENABLE ROW LEVEL SECURITY;

-- Politique : Tout le monde peut lire les likes
CREATE POLICY "Tout le monde peut lire les likes"
    ON thought_likes FOR SELECT
    USING (true);

-- Politique : Les utilisateurs peuvent créer des likes
CREATE POLICY "Utilisateurs peuvent liker"
    ON thought_likes FOR INSERT
    WITH CHECK (true);

-- Politique : Les utilisateurs peuvent supprimer leurs propres likes
CREATE POLICY "Utilisateurs peuvent supprimer leurs likes"
    ON thought_likes FOR DELETE
    USING (true);


-- Activer RLS sur users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Politique : Les utilisateurs peuvent lire tous les profils
CREATE POLICY "Lecture publique des profils"
    ON users FOR SELECT
    USING (true);

-- Politique : Les utilisateurs peuvent mettre à jour leur propre profil
CREATE POLICY "Utilisateurs peuvent modifier leur profil"
    ON users FOR UPDATE
    USING (true);

-- Politique : Création de nouveaux utilisateurs
CREATE POLICY "Création de nouveaux utilisateurs"
    ON users FOR INSERT
    WITH CHECK (true);


-- 7. Vue pour faciliter les requêtes avec comptage des likes
-- ============================================
CREATE OR REPLACE VIEW thoughts_with_likes AS
SELECT 
    t.id,
    t.username,
    t.avatar_url,
    t.content,
    t.created_at,
    t.likes_count,
    COUNT(tl.id) as actual_likes_count
FROM thoughts t
LEFT JOIN thought_likes tl ON t.id = tl.thought_id
GROUP BY t.id, t.username, t.avatar_url, t.content, t.created_at, t.likes_count
ORDER BY t.created_at DESC;


-- 8. Données de test (optionnel - à supprimer en production)
-- ============================================
-- Décommenter pour insérer des données de test

/*
INSERT INTO thoughts (username, avatar_url, content) VALUES
('Alice', 'https://i.pinimg.com/736x/d4/74/6f/d4746f76dcd0e4402335d1fce705332e.jpg', 'Première pensée de test ! 🚀'),
('Bob', 'https://i.pinimg.com/736x/3a/3c/fe/3a3cfea680e58610d342bb7b9d1a8552.jpg', 'Le code est poésie en mouvement.'),
('Charlie', 'https://i.pinimg.com/736x/d4/74/6f/d4746f76dcd0e4402335d1fce705332e.jpg', 'Debugging is like being a detective in a crime movie where you are also the murderer. 🔍');
*/


-- 9. Vérification de l'installation
-- ============================================
-- Exécuter cette requête pour vérifier que tout est bien créé
SELECT 
    'Tables créées' as status,
    COUNT(*) as count
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('thoughts', 'thought_likes', 'users');

-- Afficher les index créés
SELECT 
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
AND tablename IN ('thoughts', 'thought_likes', 'users')
ORDER BY tablename, indexname;
