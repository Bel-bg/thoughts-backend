# 📖 Index de la Documentation

Guide de navigation rapide pour tous les fichiers du projet.

---

## 🚀 Démarrage Rapide

**Vous débutez ?** Lisez dans cet ordre :

1. **[QUICK_START.md](QUICK_START.md)** - Installation en 5 minutes ⚡
2. **[database.sql](database.sql)** - Exécutez ce script dans Supabase
3. **[README.md](README.md)** - Documentation complète du projet

---

## 📚 Documentation par Thème

### 🎯 Installation & Configuration

| Document | Description | Temps de lecture |
|----------|-------------|------------------|
| [QUICK_START.md](QUICK_START.md) | Installation rapide | 5 min |
| [INSTALLATION_DB.md](INSTALLATION_DB.md) | Guide détaillé de la BDD | 15 min |
| [.env.example](.env.example) | Template de configuration | 2 min |

### 📖 Documentation Générale

| Document | Description | Temps de lecture |
|----------|-------------|------------------|
| [README.md](README.md) | Documentation principale | 20 min |
| [CHANGELOG.md](CHANGELOG.md) | Historique des versions | 5 min |
| [FILES_SUMMARY.md](FILES_SUMMARY.md) | Structure des fichiers | 10 min |

### 🗄️ Base de Données SQL

| Document | Description | Utilisation |
|----------|-------------|-------------|
| [database.sql](database.sql) | Script complet (tout-en-un) | Installation rapide |
| [SQL_FILES_GUIDE.md](SQL_FILES_GUIDE.md) | Guide des fichiers SQL | Choix d'approche |
| [test_queries.sql](test_queries.sql) | Tests et vérification | Après installation |
| [migrations/](migrations/) | Installation progressive | Production |

### 💻 Code Backend

| Fichier | Description | Rôle |
|---------|-------------|------|
| [index.js](index.js) | Point d'entrée principal | Serveur Express |
| [supabaseClient.js](supabaseClient.js) | Configuration Supabase | Connexion BDD |
| [sendNotifications.js](sendNotifications.js) | Notifications push | Service Expo |
| [removeExpired.js](removeExpired.js) | Nettoyage auto | Cron job |
| [routes/like.js](routes/like.js) | API des likes | Endpoints likes |
| [routes/Post.js](routes/Post.js) | API des posts | Endpoints posts |

---

## 🔍 Recherche par Besoin

### "Je veux..."

#### ...installer le projet rapidement
→ [QUICK_START.md](QUICK_START.md)

#### ...comprendre l'architecture
→ [README.md](README.md) - Section "Technologies"

#### ...configurer la base de données
→ [INSTALLATION_DB.md](INSTALLATION_DB.md)

#### ...voir les endpoints API
→ [README.md](README.md) - Section "API Endpoints"

#### ...tester le backend
→ [test_queries.sql](test_queries.sql)

#### ...comprendre les fichiers SQL
→ [SQL_FILES_GUIDE.md](SQL_FILES_GUIDE.md)

#### ...voir les changements récents
→ [CHANGELOG.md](CHANGELOG.md)

#### ...comprendre la structure
→ [FILES_SUMMARY.md](FILES_SUMMARY.md)

#### ...modifier les likes
→ [routes/like.js](routes/like.js)

#### ...changer la limite de caractères
→ [index.js](index.js) ligne 24

#### ...configurer les notifications
→ [sendNotifications.js](sendNotifications.js)

#### ...ajouter une nouvelle route
→ [index.js](index.js) + créer un fichier dans `routes/`

---

## 📋 Checklist d'Installation

Cochez au fur et à mesure :

### Base de Données
- [ ] Lu [INSTALLATION_DB.md](INSTALLATION_DB.md)
- [ ] Exécuté [database.sql](database.sql) dans Supabase
- [ ] Vérifié les 3 tables (thoughts, thought_likes, users)
- [ ] Testé avec [test_queries.sql](test_queries.sql)

### Backend
- [ ] Copié `.env.example` vers `.env`
- [ ] Configuré `SUPABASE_URL` et `SUPABASE_KEY`
- [ ] Exécuté `npm install`
- [ ] Démarré avec `npm start`
- [ ] Testé l'endpoint `/thoughts`

### Documentation
- [ ] Lu [README.md](README.md)
- [ ] Compris les endpoints API
- [ ] Testé avec Postman ou curl

---

## 🎓 Parcours d'Apprentissage

### Niveau 1 : Débutant (1 heure)
1. [QUICK_START.md](QUICK_START.md) - 5 min
2. Installer et démarrer - 10 min
3. [README.md](README.md) - Section "Fonctionnalités" - 10 min
4. Tester les endpoints - 15 min
5. [test_queries.sql](test_queries.sql) - Sections 1-4 - 20 min

### Niveau 2 : Intermédiaire (2 heures)
1. [README.md](README.md) complet - 20 min
2. [INSTALLATION_DB.md](INSTALLATION_DB.md) - 15 min
3. [SQL_FILES_GUIDE.md](SQL_FILES_GUIDE.md) - 10 min
4. Lire [index.js](index.js) - 20 min
5. Lire [routes/like.js](routes/like.js) - 15 min
6. Modifier et tester - 40 min

### Niveau 3 : Avancé (4 heures)
1. Tous les fichiers de documentation - 1h
2. Tout le code backend - 1h
3. Tous les fichiers SQL - 30 min
4. Créer de nouvelles fonctionnalités - 1h30

---

## 📊 Glossaire des Termes

| Terme | Définition | Fichier de référence |
|-------|------------|----------------------|
| **Pensée** | Message partagé (max 500 caractères) | [README.md](README.md) |
| **Like** | Réaction positive sur une pensée | [routes/like.js](routes/like.js) |
| **RLS** | Row Level Security (sécurité Supabase) | [INSTALLATION_DB.md](INSTALLATION_DB.md) |
| **Expo Token** | Token pour notifications push | [sendNotifications.js](sendNotifications.js) |
| **Migration** | Script SQL de mise à jour BDD | [SQL_FILES_GUIDE.md](SQL_FILES_GUIDE.md) |
| **Endpoint** | URL d'API (ex: /thoughts) | [README.md](README.md) |
| **Supabase** | Base de données PostgreSQL hébergée | [supabaseClient.js](supabaseClient.js) |

---

## 🔗 Liens Externes Utiles

### Documentation Officielle
- [Supabase Docs](https://supabase.com/docs)
- [Express.js Guide](https://expressjs.com/en/guide/routing.html)
- [Expo Push Notifications](https://docs.expo.dev/push-notifications/overview/)
- [Node.js Docs](https://nodejs.org/docs/latest/api/)

### Outils
- [Postman](https://www.postman.com/) - Tester les API
- [TablePlus](https://tableplus.com/) - Client SQL
- [VS Code](https://code.visualstudio.com/) - Éditeur de code

---

## 🆘 Support & Aide

### Problèmes Courants

| Problème | Solution | Document |
|----------|----------|----------|
| Erreur de connexion Supabase | Vérifier `.env` | [INSTALLATION_DB.md](INSTALLATION_DB.md) |
| Port déjà utilisé | Changer `PORT` dans `.env` | [QUICK_START.md](QUICK_START.md) |
| Tables inexistantes | Exécuter `database.sql` | [SQL_FILES_GUIDE.md](SQL_FILES_GUIDE.md) |
| Erreur de contrainte SQL | Vérifier limite 500 caractères | [README.md](README.md) |

### Où Chercher ?

1. **Erreur d'installation** → [QUICK_START.md](QUICK_START.md) section "Problèmes Courants"
2. **Erreur SQL** → [INSTALLATION_DB.md](INSTALLATION_DB.md) section "Dépannage"
3. **Erreur API** → [README.md](README.md) section "API Endpoints"
4. **Question générale** → [FILES_SUMMARY.md](FILES_SUMMARY.md)

---

## 📝 Contribuer

Pour contribuer au projet :

1. Lire [README.md](README.md)
2. Comprendre [FILES_SUMMARY.md](FILES_SUMMARY.md)
3. Modifier le code
4. Tester avec [test_queries.sql](test_queries.sql)
5. Mettre à jour [CHANGELOG.md](CHANGELOG.md)
6. Documenter dans [README.md](README.md)

---

## 🎯 Objectifs par Rôle

### Développeur Backend
**À lire en priorité :**
1. [README.md](README.md)
2. [index.js](index.js)
3. [routes/like.js](routes/like.js)
4. [test_queries.sql](test_queries.sql)

### Administrateur BDD
**À lire en priorité :**
1. [INSTALLATION_DB.md](INSTALLATION_DB.md)
2. [database.sql](database.sql)
3. [SQL_FILES_GUIDE.md](SQL_FILES_GUIDE.md)
4. [test_queries.sql](test_queries.sql)

### Chef de Projet
**À lire en priorité :**
1. [README.md](README.md)
2. [CHANGELOG.md](CHANGELOG.md)
3. [FILES_SUMMARY.md](FILES_SUMMARY.md)
4. [QUICK_START.md](QUICK_START.md)

### Développeur Frontend
**À lire en priorité :**
1. [README.md](README.md) - Section "API Endpoints"
2. [QUICK_START.md](QUICK_START.md) - Section "Test Rapide"
3. [test_queries.sql](test_queries.sql) - Pour comprendre les données

---

## 📅 Dernière Mise à Jour

- **Date** : 2025-10-07
- **Version** : 2.0.0
- **Fichiers** : 20+
- **Documentation** : Complète ✅

---

**Navigation** : [Retour au README](README.md) | [Quick Start](QUICK_START.md) | [Installation BDD](INSTALLATION_DB.md)
