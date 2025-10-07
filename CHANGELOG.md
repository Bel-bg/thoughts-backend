# 📝 Changelog

Historique des modifications du backend de partage de pensées.

## [2.0.0] - 2025-10-07

### 🎉 Améliorations Majeures

#### Backend
- ✅ **Augmentation de la limite de caractères** : Passage de 60 à 500 caractères
- ✅ **Likes en temps réel** : Comptage instantané et synchronisation via Supabase
- ✅ **Notifications améliorées** : 
  - Notifications lors de nouvelles pensées
  - Notifications lors de nouveaux likes avec aperçu du contenu
- ✅ **Meilleure gestion des erreurs** : Logs détaillés et messages explicites
- ✅ **Optimisation des requêtes** : Utilisation de `maybeSingle()` pour éviter les erreurs

#### Frontend
- ✅ **NoteSection.js** : Passage de l'`user_id` pour vérifier les likes
- ✅ **newNote.js** : Limite de 500 caractères avec commentaire explicatif
- ✅ **Synchronisation** : Frontend et backend parfaitement alignés

#### Base de Données
- ✅ **Scripts SQL complets** : Installation facilitée
- ✅ **Migrations structurées** : Approche professionnelle
- ✅ **Politiques de sécurité** : Row Level Security (RLS) activé
- ✅ **Fonctions utilitaires** : Nettoyage automatique et vues optimisées

#### Documentation
- ✅ **README.md** : Documentation complète et détaillée
- ✅ **INSTALLATION_DB.md** : Guide d'installation de la base de données
- ✅ **QUICK_START.md** : Installation rapide en 5 minutes
- ✅ **SQL_FILES_GUIDE.md** : Guide des fichiers SQL
- ✅ **test_queries.sql** : Requêtes de test et vérification
- ✅ **.env.example** : Template de configuration

### 🔧 Modifications Techniques

#### `index.js`
```javascript
// Avant
if (!content || content.length > 60) {

// Après
if (!content || content.length > 500) {
  return res.status(400).json({ 
    error: "Pensée trop longue (max 500 caractères) ou vide" 
  });
}
```

#### `routes/like.js`
- Ajout de notifications lors des likes
- Aperçu du contenu dans les notifications (50 premiers caractères)
- Gestion des erreurs sans bloquer les requêtes

#### `app/messaging/NoteSection.js`
- Passage de `user_id` dans les requêtes GET
- Meilleure construction de l'URL avec paramètres

### 📊 Statistiques

- **Fichiers modifiés** : 5
- **Fichiers créés** : 10
- **Lignes de code ajoutées** : ~1500
- **Documentation** : 6 nouveaux fichiers

---

## [1.0.0] - Date Initiale

### 🎉 Version Initiale

#### Fonctionnalités
- Publication de pensées (max 60 caractères)
- Récupération des pensées
- Système de likes basique
- Notifications push pour nouvelles pensées
- Expiration automatique après 24h

#### Technologies
- Node.js + Express
- Supabase (PostgreSQL)
- Expo Push Notifications
- node-cron

---

## 🔮 Prochaines Versions

### [2.1.0] - À venir
- [ ] Commentaires sur les pensées
- [ ] Partage de pensées
- [ ] Statistiques utilisateur
- [ ] Mode sombre

### [2.2.0] - À venir
- [ ] Hashtags
- [ ] Recherche de pensées
- [ ] Filtres par utilisateur
- [ ] Pensées épinglées

### [3.0.0] - À venir
- [ ] Médias (images, vidéos)
- [ ] Stories éphémères
- [ ] Messages privés
- [ ] Groupes de discussion

---

## 📝 Notes de Migration

### De 1.0.0 vers 2.0.0

#### Backend
1. Mettre à jour `index.js` avec la nouvelle limite de 500 caractères
2. Mettre à jour `routes/like.js` avec les notifications
3. Redémarrer le serveur

#### Base de Données
1. Aucune migration nécessaire (la contrainte SQL accepte déjà 500 caractères)
2. Optionnel : Exécuter `database.sql` pour avoir toutes les améliorations

#### Frontend
1. Vérifier que `newNote.js` a `ceilling = 500`
2. Mettre à jour `NoteSection.js` pour passer `user_id`
3. Recompiler l'application mobile

---

## 🐛 Corrections de Bugs

### Version 2.0.0
- ✅ Correction : Erreur lors du comptage des likes
- ✅ Correction : Vérification du statut "liké" pour chaque utilisateur
- ✅ Correction : Gestion des erreurs de notification sans bloquer les requêtes

---

## 🙏 Contributeurs

- **Développeur Principal** : Équipe IG-Live ENEAM

---

## 📄 Licence

ISC
