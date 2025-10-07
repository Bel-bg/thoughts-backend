-- Migration 003: Fonctions et vues utilitaires
-- Date: 2025-10-07
-- Description: Création des fonctions et vues pour faciliter les opérations

-- Fonction pour mettre à jour automatiquement updated_at
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

-- Fonction pour supprimer les pensées expirées (>24h)
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

-- Vue pour faciliter les requêtes avec comptage des likes
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
