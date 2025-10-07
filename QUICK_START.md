# 🚀 Quick Start - Backend Pensées

Guide rapide pour démarrer le backend en 5 minutes.

## ⚡ Installation Express

### Étape 1 : Base de Données (2 min)

1. Allez sur [Supabase](https://supabase.com) → Votre projet → **SQL Editor**
2. Copiez-collez le contenu de `database.sql`
3. Cliquez sur **Run** ✅

### Étape 2 : Configuration (1 min)

```bash
# Copier le fichier d'exemple
cp .env.example .env

# Éditer .env avec vos clés Supabase
# SUPABASE_URL=votre_url
# SUPABASE_KEY=votre_clé
```

### Étape 3 : Démarrage (2 min)

```bash
# Installer les dépendances
npm install

# Démarrer le serveur
npm start
```

Votre backend est maintenant accessible sur `http://localhost:3000` ! 🎉

## 🧪 Test Rapide

### Tester avec curl

```bash
# Publier une pensée
curl -X POST http://localhost:3000/post-thought \
  -H "Content-Type: application/json" \
  -d '{
    "username": "Test User",
    "avatar_url": "https://example.com/avatar.jpg",
    "content": "Ma première pensée !"
  }'

# Récupérer toutes les pensées
curl http://localhost:3000/thoughts
```

### Tester avec Postman

1. **POST** `http://localhost:3000/post-thought`
   ```json
   {
     "username": "Test User",
     "avatar_url": "https://example.com/avatar.jpg",
     "content": "Ma première pensée !"
   }
   ```

2. **GET** `http://localhost:3000/thoughts`

3. **POST** `http://localhost:3000/api/like/thought`
   ```json
   {
     "thought_id": "uuid-de-la-pensée",
     "user_id": "user123"
   }
   ```

## 📁 Structure des Fichiers

```
Backend_Notes/
├── index.js                 # Point d'entrée principal
├── supabaseClient.js        # Configuration Supabase
├── sendNotifications.js     # Service de notifications
├── removeExpired.js         # Nettoyage automatique
├── .env                     # Variables d'environnement
├── database.sql             # Script SQL complet
├── INSTALLATION_DB.md       # Guide détaillé BDD
├── test_queries.sql         # Requêtes de test
├── routes/
│   ├── like.js             # Routes des likes
│   ├── Post.js             # Routes des posts
│   └── comments.js         # Routes des commentaires
└── migrations/
    ├── 001_initial_setup.sql
    ├── 002_security_policies.sql
    └── 003_functions_and_views.sql
```

## 🔧 Commandes Utiles

```bash
# Démarrer le serveur
npm start

# Vérifier les logs
# Les logs s'affichent dans la console

# Arrêter le serveur
Ctrl + C
```

## 📊 Vérifier que tout fonctionne

### Dans Supabase

1. Allez dans **Table Editor**
2. Vérifiez que vous voyez :
   - ✅ `thoughts`
   - ✅ `thought_likes`
   - ✅ `users`

### Dans votre terminal

Vous devriez voir :
```
🚀 Serveur lancé sur http://localhost:3000
```

### Tester l'API

```bash
# Devrait retourner un tableau (vide ou avec des pensées)
curl http://localhost:3000/thoughts
```

## ❓ Problèmes Courants

### Erreur : "Cannot connect to Supabase"
- ✅ Vérifiez votre `.env`
- ✅ Vérifiez que `SUPABASE_URL` et `SUPABASE_KEY` sont corrects

### Erreur : "Port 3000 already in use"
- ✅ Changez le port dans `.env` : `PORT=3001`
- ✅ Ou arrêtez l'autre processus sur le port 3000

### Erreur : "relation does not exist"
- ✅ Exécutez le script `database.sql` dans Supabase
- ✅ Vérifiez que les tables sont créées

## 🎯 Prochaines Étapes

1. ✅ Testez tous les endpoints avec Postman
2. ✅ Connectez votre frontend mobile
3. ✅ Configurez les notifications push Expo
4. ✅ Déployez sur Render/Heroku/Railway

## 📚 Documentation Complète

- **README.md** : Documentation complète du projet
- **INSTALLATION_DB.md** : Guide détaillé de la base de données
- **database.sql** : Script SQL complet avec commentaires

## 🆘 Besoin d'Aide ?

- Consultez le README.md pour plus de détails
- Vérifiez les logs dans la console
- Testez avec `test_queries.sql` dans Supabase

---

**Temps total d'installation : ~5 minutes** ⚡
