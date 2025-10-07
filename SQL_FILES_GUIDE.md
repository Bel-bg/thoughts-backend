# 📚 Guide des Fichiers SQL

Ce document explique l'utilisation de chaque fichier SQL du projet.

## 📁 Fichiers Disponibles

### 1. `database.sql` - Script Complet ⭐
**Utilisation recommandée pour une installation rapide**

- **Contenu** : Tout en un seul fichier
  - Création des tables
  - Index et contraintes
  - Politiques de sécurité (RLS)
  - Fonctions et vues
  - Données de test (commentées)

- **Quand l'utiliser** :
  - ✅ Première installation
  - ✅ Réinitialisation complète
  - ✅ Environnement de développement

- **Comment l'utiliser** :
  1. Ouvrez Supabase SQL Editor
  2. Copiez tout le contenu de `database.sql`
  3. Cliquez sur **Run**
  4. Vérifiez que tout est créé ✅

---

### 2. Dossier `migrations/` - Installation Progressive

Pour une approche plus structurée et professionnelle.

#### `001_initial_setup.sql`
- **Contenu** : Tables de base uniquement
- **Crée** :
  - Table `thoughts`
  - Table `thought_likes`
  - Table `users`
  - Index de performance

#### `002_security_policies.sql`
- **Contenu** : Politiques de sécurité
- **Configure** :
  - Row Level Security (RLS)
  - Politiques de lecture/écriture
  - Permissions par table

#### `003_functions_and_views.sql`
- **Contenu** : Fonctions et vues utilitaires
- **Crée** :
  - Fonction `delete_expired_thoughts()`
  - Fonction `update_updated_at_column()`
  - Vue `thoughts_with_likes`
  - Triggers automatiques

**Ordre d'exécution** :
```sql
-- 1. Tables
\i migrations/001_initial_setup.sql

-- 2. Sécurité
\i migrations/002_security_policies.sql

-- 3. Fonctions
\i migrations/003_functions_and_views.sql
```

---

### 3. `test_queries.sql` - Tests et Vérification 🧪

- **Contenu** : Requêtes de test et vérification
- **Sections** :
  1. Vérification de l'installation
  2. Insertion de données de test
  3. Tests de likes
  4. Tests de contraintes
  5. Statistiques
  6. Tests de performance
  7. Vérification de la sécurité

- **Quand l'utiliser** :
  - ✅ Après l'installation pour vérifier
  - ✅ Pour tester les fonctionnalités
  - ✅ Pour déboguer des problèmes
  - ✅ Pour voir des exemples de requêtes

- **Comment l'utiliser** :
  1. Ouvrez Supabase SQL Editor
  2. Copiez les sections qui vous intéressent
  3. Exécutez-les une par une
  4. Vérifiez les résultats

---

## 🎯 Quelle Approche Choisir ?

### Option A : Installation Rapide (Recommandée pour débuter)
```
1. Exécuter database.sql
2. Vérifier avec test_queries.sql
✅ Terminé en 2 minutes !
```

### Option B : Installation Progressive (Recommandée pour production)
```
1. Exécuter migrations/001_initial_setup.sql
2. Exécuter migrations/002_security_policies.sql
3. Exécuter migrations/003_functions_and_views.sql
4. Vérifier avec test_queries.sql
✅ Plus structuré et traçable
```

---

## 📊 Comparaison

| Critère | database.sql | migrations/ |
|---------|--------------|-------------|
| **Rapidité** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Structure** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Traçabilité** | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Débogage** | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Production** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 🔄 Workflow Recommandé

### Développement Local
```bash
1. database.sql (installation rapide)
2. test_queries.sql (vérification)
3. Développer et tester
```

### Production
```bash
1. migrations/001_initial_setup.sql
2. migrations/002_security_policies.sql
3. migrations/003_functions_and_views.sql
4. test_queries.sql (vérification)
5. Documenter la version
```

---

## 🛠️ Commandes Utiles

### Vérifier l'installation
```sql
-- Voir toutes les tables
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Compter les données
SELECT 
    (SELECT COUNT(*) FROM thoughts) as thoughts,
    (SELECT COUNT(*) FROM thought_likes) as likes,
    (SELECT COUNT(*) FROM users) as users;
```

### Réinitialiser (⚠️ ATTENTION)
```sql
-- Supprimer toutes les données
DROP TABLE IF EXISTS thought_likes CASCADE;
DROP TABLE IF EXISTS thoughts CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Puis réexécuter database.sql ou les migrations
```

### Backup avant modifications
```sql
-- Sauvegarder les pensées
CREATE TABLE thoughts_backup AS SELECT * FROM thoughts;

-- Sauvegarder les likes
CREATE TABLE thought_likes_backup AS SELECT * FROM thought_likes;

-- Restaurer si besoin
INSERT INTO thoughts SELECT * FROM thoughts_backup;
```

---

## 📝 Notes Importantes

### Sécurité
- ✅ Ne jamais commiter `.env` avec vos vraies clés
- ✅ Utiliser `.env.example` pour la documentation
- ✅ Les politiques RLS sont activées par défaut

### Performance
- ✅ Les index sont créés automatiquement
- ✅ Les contraintes garantissent l'intégrité des données
- ✅ Les vues optimisent les requêtes fréquentes

### Maintenance
- ✅ Les pensées expirent automatiquement après 24h
- ✅ La fonction `delete_expired_thoughts()` peut être appelée manuellement
- ✅ Les triggers mettent à jour `updated_at` automatiquement

---

## 🆘 Dépannage

### Erreur : "relation already exists"
**Solution** : Les tables existent déjà, pas besoin de les recréer.

### Erreur : "permission denied"
**Solution** : Vérifiez que vous êtes connecté avec les bons droits sur Supabase.

### Erreur : "constraint violation"
**Solution** : Vérifiez que vos données respectent les contraintes (ex: max 500 caractères).

---

## 📚 Ressources

- **INSTALLATION_DB.md** : Guide détaillé d'installation
- **QUICK_START.md** : Installation rapide en 5 minutes
- **README.md** : Documentation complète du projet

---

**Besoin d'aide ?** Consultez les autres fichiers de documentation ou les commentaires dans les fichiers SQL.
