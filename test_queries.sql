-- ============================================
-- Requêtes de test pour la base de données
-- ============================================

-- 1. VÉRIFICATION DE L'INSTALLATION
-- ============================================

-- Vérifier que toutes les tables existent
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('thoughts', 'thought_likes', 'users')
ORDER BY table_name;

-- Vérifier les colonnes de la table thoughts
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'thoughts'
ORDER BY ordinal_position;


-- 2. INSERTION DE DONNÉES DE TEST
-- ============================================

-- Insérer des pensées de test
INSERT INTO thoughts (username, avatar_url, content) VALUES
('Alice', 'https://i.pinimg.com/736x/d4/74/6f/d4746f76dcd0e4402335d1fce705332e.jpg', 'Première pensée de test ! 🚀'),
('Bob', 'https://i.pinimg.com/736x/3a/3c/fe/3a3cfea680e58610d342bb7b9d1a8552.jpg', 'Le code est poésie en mouvement.'),
('Charlie', 'https://i.pinimg.com/736x/d4/74/6f/d4746f76dcd0e4402335d1fce705332e.jpg', 'Debugging is like being a detective in a crime movie where you are also the murderer. 🔍'),
('Diana', 'https://i.pinimg.com/736x/3a/3c/fe/3a3cfea680e58610d342bb7b9d1a8552.jpg', 'La programmation, c''est comme l''art : il faut savoir quand s''arrêter. 🎨'),
('Eve', 'https://i.pinimg.com/736x/d4/74/6f/d4746f76dcd0e4402335d1fce705332e.jpg', 'Un bug corrigé est une victoire célébrée ! 🎉');

-- Insérer des utilisateurs de test
INSERT INTO users (firebase_uid, username, email, expo_token) VALUES
('test_uid_1', 'Alice', 'alice@test.com', 'ExponentPushToken[test1]'),
('test_uid_2', 'Bob', 'bob@test.com', 'ExponentPushToken[test2]'),
('test_uid_3', 'Charlie', 'charlie@test.com', 'ExponentPushToken[test3]')
ON CONFLICT (firebase_uid) DO NOTHING;


-- 3. TESTS DE LIKES
-- ============================================

-- Récupérer l'ID de la première pensée pour tester les likes
DO $$
DECLARE
    first_thought_id UUID;
BEGIN
    SELECT id INTO first_thought_id FROM thoughts LIMIT 1;
    
    -- Ajouter des likes de test
    INSERT INTO thought_likes (thought_id, user_id) VALUES
    (first_thought_id, 'test_uid_1'),
    (first_thought_id, 'test_uid_2'),
    (first_thought_id, 'test_uid_3')
    ON CONFLICT (thought_id, user_id) DO NOTHING;
END $$;


-- 4. REQUÊTES DE VÉRIFICATION
-- ============================================

-- Afficher toutes les pensées avec leur nombre de likes
SELECT 
    t.id,
    t.username,
    t.content,
    t.likes_count,
    COUNT(tl.id) as actual_likes,
    t.created_at
FROM thoughts t
LEFT JOIN thought_likes tl ON t.id = tl.thought_id
GROUP BY t.id, t.username, t.content, t.likes_count, t.created_at
ORDER BY t.created_at DESC;

-- Afficher les pensées via la vue
SELECT * FROM thoughts_with_likes;

-- Compter le nombre total de pensées
SELECT COUNT(*) as total_thoughts FROM thoughts;

-- Compter le nombre total de likes
SELECT COUNT(*) as total_likes FROM thought_likes;

-- Afficher les utilisateurs avec leurs tokens
SELECT 
    username,
    email,
    expo_token,
    created_at
FROM users
ORDER BY created_at DESC;


-- 5. TESTS DE CONTRAINTES
-- ============================================

-- Test : Pensée trop longue (devrait échouer)
-- Décommenter pour tester
/*
INSERT INTO thoughts (username, content) 
VALUES ('Test', REPEAT('a', 501));
*/

-- Test : Pensée vide (devrait échouer)
-- Décommenter pour tester
/*
INSERT INTO thoughts (username, content) 
VALUES ('Test', '   ');
*/

-- Test : Double like (devrait échouer)
-- Décommenter pour tester
/*
DO $$
DECLARE
    first_thought_id UUID;
BEGIN
    SELECT id INTO first_thought_id FROM thoughts LIMIT 1;
    INSERT INTO thought_likes (thought_id, user_id) VALUES
    (first_thought_id, 'test_uid_1');
END $$;
*/


-- 6. STATISTIQUES
-- ============================================

-- Pensée la plus likée
SELECT 
    t.username,
    t.content,
    COUNT(tl.id) as likes_count
FROM thoughts t
LEFT JOIN thought_likes tl ON t.id = tl.thought_id
GROUP BY t.id, t.username, t.content
ORDER BY likes_count DESC
LIMIT 5;

-- Utilisateur le plus actif (qui like le plus)
SELECT 
    user_id,
    COUNT(*) as total_likes_given
FROM thought_likes
GROUP BY user_id
ORDER BY total_likes_given DESC
LIMIT 5;

-- Pensées par utilisateur
SELECT 
    username,
    COUNT(*) as thoughts_count
FROM thoughts
GROUP BY username
ORDER BY thoughts_count DESC;


-- 7. NETTOYAGE (OPTIONNEL)
-- ============================================

-- Supprimer toutes les données de test
-- ⚠️ ATTENTION : Décommenter uniquement si vous voulez tout supprimer !
/*
DELETE FROM thought_likes;
DELETE FROM thoughts;
DELETE FROM users WHERE firebase_uid LIKE 'test_uid_%';
*/

-- Supprimer uniquement les pensées expirées
-- SELECT delete_expired_thoughts();


-- 8. TESTS DE PERFORMANCE
-- ============================================

-- Analyser les performances de la requête principale
EXPLAIN ANALYZE
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
ORDER BY t.created_at DESC
LIMIT 20;


-- 9. VÉRIFICATION DE LA SÉCURITÉ (RLS)
-- ============================================

-- Vérifier que RLS est activé
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('thoughts', 'thought_likes', 'users');

-- Afficher toutes les politiques
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;


-- 10. RÉSUMÉ GLOBAL
-- ============================================

SELECT 
    'Pensées' as type,
    COUNT(*) as count
FROM thoughts
UNION ALL
SELECT 
    'Likes' as type,
    COUNT(*) as count
FROM thought_likes
UNION ALL
SELECT 
    'Utilisateurs' as type,
    COUNT(*) as count
FROM users;
