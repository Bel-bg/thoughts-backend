# Backend de Partage de Pensées - IG-Live

Backend Node.js/Express pour le service de partage de pensées de l'application mobile IG-Live.

> 📖 **Navigation** : [Index de la Documentation](INDEX.md) | [Quick Start](QUICK_START.md) | [Installation BDD](INSTALLATION_DB.md)

## 🚀 Fonctionnalités

### ✅ Gestion des Pensées
- **Publication de pensées** : Les utilisateurs peuvent partager des pensées jusqu'à **500 caractères**
- **Récupération des pensées** : Affichage en temps réel de toutes les pensées avec tri par date
- **Expiration automatique** : Les pensées sont automatiquement supprimées après 24h

### 💝 Système de Likes
- **Like/Unlike en temps réel** : Les utilisateurs peuvent liker ou retirer leur like sur les pensées
- **Comptage en temps réel** : Le nombre de likes est mis à jour instantanément
- **Vérification du statut** : Le backend vérifie si l'utilisateur a déjà liké une pensée
- **Notifications** : Envoi de notifications push lors de nouveaux likes

### 🔔 Notifications Push
- **Nouvelles pensées** : Notification envoyée à tous les utilisateurs lors d'une nouvelle publication
- **Nouveaux likes** : Notification envoyée lors d'un like sur une pensée
- **Intégration Expo** : Utilise l'API Expo Push Notifications

### 🔄 Temps Réel
- **Supabase Realtime** : Synchronisation en temps réel des likes via PostgreSQL
- **Mise à jour automatique** : Le frontend reçoit les mises à jour sans rechargement manuel

## 📋 API Endpoints

### POST `/post-thought`
Publier une nouvelle pensée

**Body:**
```json
{
  "username": "string",
  "avatar_url": "string",
  "content": "string (max 500 caractères)"
}
```

**Response:** `201 Created`
```json
{
  "id": "uuid",
  "username": "string",
  "avatar_url": "string",
  "content": "string",
  "created_at": "timestamp",
  "likes_count": 0
}
```

### GET `/thoughts`
Récupérer toutes les pensées

**Query Parameters:**
- `user_id` (optionnel) : ID de l'utilisateur pour vérifier les likes

**Response:** `200 OK`
```json
[
  {
    "id": "uuid",
    "username": "string",
    "avatar_url": "string",
    "content": "string",
    "created_at": "timestamp",
    "likes_count": 0,
    "isLiked": false,
    "thought_likes": [{"count": 0}]
  }
]
```

### POST `/api/like/thought`
Liker ou retirer le like d'une pensée

**Body:**
```json
{
  "thought_id": "uuid",
  "user_id": "string"
}
```

**Response:** `200 OK`
```json
{
  "isLiked": true,
  "likes_count": 5
}
```

## 🛠️ Technologies

- **Node.js** + **Express** : Serveur backend
- **Supabase** : Base de données PostgreSQL + Realtime
- **Expo Push Notifications** : Notifications push
- **node-cron** : Tâches planifiées (nettoyage automatique)
- **CORS** : Gestion des requêtes cross-origin

## 📦 Installation

### 1. Configurer la Base de Données

```bash
# Voir le guide détaillé dans INSTALLATION_DB.md
```

1. Connectez-vous à [Supabase](https://supabase.com)
2. Ouvrez le **SQL Editor**
3. Exécutez le fichier `database.sql` (ou les migrations dans `migrations/`)
4. Vérifiez que les 3 tables sont créées : `thoughts`, `thought_likes`, `users`

### 2. Installer les Dépendances Backend

```bash
# Installer les dépendances
npm install

# Configurer les variables d'environnement
cp .env.example .env
# Éditer .env avec vos clés Supabase

# Démarrer le serveur
npm start
```

## 🔧 Configuration

Créer un fichier `.env` avec :

```env
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_anon_key
PORT=3000
```

## 📊 Structure de la Base de Données

### Table `thoughts`
- `id` : UUID (Primary Key)
- `username` : VARCHAR
- `avatar_url` : TEXT
- `content` : TEXT (max 500 caractères)
- `created_at` : TIMESTAMP
- `likes_count` : INTEGER (default 0)

### Table `thought_likes`
- `id` : UUID (Primary Key)
- `thought_id` : UUID (Foreign Key → thoughts.id)
- `user_id` : VARCHAR
- `created_at` : TIMESTAMP

### Table `users`
- `id` : UUID (Primary Key)
- `expo_token` : VARCHAR (pour les notifications push)

## 🔄 Améliorations Récentes

### Version 2.0 (Octobre 2025)
- ✅ **Augmentation de la limite** : Passage de 60 à 500 caractères
- ✅ **Likes en temps réel** : Comptage et synchronisation instantanés
- ✅ **Notifications améliorées** : Notifications pour les likes et nouvelles pensées
- ✅ **Meilleure gestion des erreurs** : Logs détaillés et messages d'erreur explicites
- ✅ **Optimisation des requêtes** : Utilisation de `maybeSingle()` pour éviter les erreurs

## 📝 Notes de Développement

- Les pensées sont automatiquement supprimées après 24h via `removeExpired.js`
- Le système de likes utilise un toggle (like/unlike) pour une meilleure UX
- Les notifications sont envoyées par batch de 100 pour respecter les limites d'Expo
- Le comptage des likes est fait en temps réel à chaque requête pour garantir la précision

## 🤝 Contribution

Ce backend fait partie du projet IG-Live ENEAM Mobile.

## 📄 Licence

ISC

---

## 📁 Fichiers du Projet

```
Backend_Notes/
├── 📄 README.md                    ← Vous êtes ici
├── 📖 INDEX.md                     ← Navigation complète
├── ⚡ QUICK_START.md               ← Installation rapide (5 min)
├── 🗄️ INSTALLATION_DB.md           ← Guide BDD détaillé
├── 📊 SUMMARY.md                   ← Résumé du projet
├── 📝 CHANGELOG.md                 ← Historique des versions
├── 📁 FILES_SUMMARY.md             ← Structure des fichiers
├── 🗂️ SQL_FILES_GUIDE.md           ← Guide des fichiers SQL
│
├── 💻 Code Backend
│   ├── index.js                    ← Point d'entrée principal
│   ├── supabaseClient.js           ← Configuration Supabase
│   ├── sendNotifications.js        ← Notifications push
│   ├── removeExpired.js            ← Nettoyage automatique
│   └── routes/
│       ├── like.js                 ← API des likes
│       ├── Post.js                 ← API des posts
│       └── comments.js             ← API des commentaires
│
├── 🗄️ Base de Données
│   ├── database.sql                ← Script SQL complet
│   ├── test_queries.sql            ← Requêtes de test
│   └── migrations/
│       ├── 001_initial_setup.sql
│       ├── 002_security_policies.sql
│       └── 003_functions_and_views.sql
│
└── ⚙️ Configuration
    ├── .env                        ← Variables d'environnement
    ├── .env.example                ← Template de configuration
    ├── .gitignore                  ← Fichiers à ignorer
    └── package.json                ← Dépendances Node.js
```

---

## 🎯 Liens Rapides

- 📖 [Index de la Documentation](INDEX.md)
- ⚡ [Quick Start - Installation en 5 min](QUICK_START.md)
- 🗄️ [Guide d'Installation BDD](INSTALLATION_DB.md)
- 📊 [Résumé du Projet](SUMMARY.md)
- 📝 [Changelog](CHANGELOG.md)
- 🗂️ [Guide des Fichiers SQL](SQL_FILES_GUIDE.md)
- 📁 [Structure des Fichiers](FILES_SUMMARY.md)
