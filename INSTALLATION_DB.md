# 🗄️ Installation de la Base de Données Supabase

Guide d'installation pour configurer la base de données du service de partage de pensées.

## 📋 Prérequis

- Un compte Supabase actif
- Accès au SQL Editor de votre projet Supabase

## 🚀 Installation Rapide

### Étape 1 : Accéder au SQL Editor

1. Connectez-vous à [Supabase](https://supabase.com)
2. Sélectionnez votre projet
3. Allez dans **SQL Editor** (dans le menu latéral)

### Étape 2 : Exécuter le Script SQL

1. Cliquez sur **New Query**
2. Copiez tout le contenu du fichier `database.sql`
3. Collez-le dans l'éditeur SQL
4. Cliquez sur **Run** (ou appuyez sur `Ctrl + Enter`)

### Étape 3 : Vérifier l'Installation

Exécutez cette requête pour vérifier que tout est bien créé :

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('thoughts', 'thought_likes', 'users');
```

Vous devriez voir 3 tables :
- ✅ `thoughts`
- ✅ `thought_likes`
- ✅ `users`

## 📊 Structure des Tables

### Table `thoughts`
Stocke les pensées partagées par les utilisateurs.

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | UUID | Identifiant unique (auto-généré) |
| `username` | VARCHAR(255) | Nom de l'utilisateur |
| `avatar_url` | TEXT | URL de l'avatar |
| `content` | TEXT | Contenu de la pensée (max 500 caractères) |
| `created_at` | TIMESTAMP | Date de création |
| `likes_count` | INTEGER | Nombre de likes (mis à jour automatiquement) |

### Table `thought_likes`
Stocke les likes sur les pensées.

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | UUID | Identifiant unique |
| `thought_id` | UUID | Référence vers `thoughts.id` |
| `user_id` | VARCHAR(255) | ID de l'utilisateur qui a liké |
| `created_at` | TIMESTAMP | Date du like |

**Contrainte** : Un utilisateur ne peut liker qu'une seule fois la même pensée.

### Table `users`
Stocke les informations des utilisateurs pour les notifications.

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | UUID | Identifiant unique |
| `firebase_uid` | VARCHAR(255) | UID Firebase (unique) |
| `username` | VARCHAR(255) | Nom d'utilisateur |
| `email` | VARCHAR(255) | Email |
| `avatar_url` | TEXT | URL de l'avatar |
| `avatar_id` | VARCHAR(50) | ID de l'avatar sélectionné |
| `expo_token` | VARCHAR(255) | Token Expo pour les notifications push |
| `created_at` | TIMESTAMP | Date de création |
| `updated_at` | TIMESTAMP | Date de dernière mise à jour |

## 🔒 Sécurité (Row Level Security)

Le script active automatiquement les politiques de sécurité :

### Pensées (`thoughts`)
- ✅ **Lecture** : Tout le monde peut lire les pensées
- ✅ **Création** : Les utilisateurs authentifiés peuvent créer
- ✅ **Suppression** : Automatique après 24h

### Likes (`thought_likes`)
- ✅ **Lecture** : Tout le monde peut voir les likes
- ✅ **Création** : Les utilisateurs peuvent liker
- ✅ **Suppression** : Les utilisateurs peuvent retirer leurs likes

### Utilisateurs (`users`)
- ✅ **Lecture** : Profils publics
- ✅ **Mise à jour** : Chaque utilisateur peut modifier son profil
- ✅ **Création** : Nouveaux utilisateurs peuvent s'inscrire

## 🔧 Fonctions Utiles

### Supprimer les pensées expirées

```sql
SELECT delete_expired_thoughts();
```

Cette fonction supprime toutes les pensées de plus de 24h et retourne le nombre de pensées supprimées.

### Voir les pensées avec comptage des likes

```sql
SELECT * FROM thoughts_with_likes;
```

Cette vue affiche toutes les pensées avec le comptage en temps réel des likes.

## 🧪 Données de Test (Optionnel)

Pour tester votre installation, vous pouvez insérer des données de test :

```sql
INSERT INTO thoughts (username, avatar_url, content) VALUES
('Alice', 'https://i.pinimg.com/736x/d4/74/6f/d4746f76dcd0e4402335d1fce705332e.jpg', 'Première pensée de test ! 🚀'),
('Bob', 'https://i.pinimg.com/736x/3a/3c/fe/3a3cfea680e58610d342bb7b9d1a8552.jpg', 'Le code est poésie en mouvement.'),
('Charlie', 'https://i.pinimg.com/736x/d4/74/6f/d4746f76dcd0e4402335d1fce705332e.jpg', 'Debugging is like being a detective in a crime movie where you are also the murderer. 🔍');
```

**⚠️ Important** : Supprimez ces données de test avant de passer en production !

## 🔄 Maintenance

### Nettoyer les pensées expirées manuellement

```sql
DELETE FROM thoughts WHERE created_at < NOW() - INTERVAL '24 hours';
```

### Voir les statistiques

```sql
-- Nombre total de pensées
SELECT COUNT(*) as total_thoughts FROM thoughts;

-- Nombre total de likes
SELECT COUNT(*) as total_likes FROM thought_likes;

-- Pensée la plus likée
SELECT t.username, t.content, COUNT(tl.id) as likes
FROM thoughts t
LEFT JOIN thought_likes tl ON t.id = tl.thought_id
GROUP BY t.id, t.username, t.content
ORDER BY likes DESC
LIMIT 1;
```

## 📝 Notes Importantes

1. **Backup** : Pensez à faire des sauvegardes régulières de votre base de données
2. **Index** : Les index sont créés automatiquement pour optimiser les performances
3. **Cascade** : La suppression d'une pensée supprime automatiquement tous ses likes
4. **Contraintes** : Les pensées ne peuvent pas dépasser 500 caractères ni être vides

## 🆘 Dépannage

### Erreur : "relation already exists"
Si vous voyez cette erreur, c'est que les tables existent déjà. Vous pouvez :
- Ignorer l'erreur (les tables sont déjà créées)
- Ou supprimer les tables existantes avant de réexécuter le script :

```sql
DROP TABLE IF EXISTS thought_likes CASCADE;
DROP TABLE IF EXISTS thoughts CASCADE;
DROP TABLE IF EXISTS users CASCADE;
```

### Erreur : "permission denied"
Assurez-vous d'être connecté avec un compte ayant les droits d'administration sur Supabase.

## ✅ Checklist Post-Installation

- [ ] Les 3 tables sont créées (`thoughts`, `thought_likes`, `users`)
- [ ] Les index sont créés
- [ ] Les politiques RLS sont activées
- [ ] La fonction `delete_expired_thoughts()` existe
- [ ] La vue `thoughts_with_likes` est créée
- [ ] Les données de test sont insérées (optionnel)
- [ ] Le backend se connecte correctement à la base de données

## 🚀 Prochaines Étapes

Une fois la base de données configurée :
1. Vérifiez que votre fichier `.env` contient les bonnes clés Supabase
2. Démarrez le backend : `npm start`
3. Testez l'API avec Postman ou votre frontend

---

**Besoin d'aide ?** Consultez la [documentation Supabase](https://supabase.com/docs) ou le README du projet.
