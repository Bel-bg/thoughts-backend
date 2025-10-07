const express = require("express");
const cors = require("cors");
const supabase = require("../supabaseClient");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

// 🚀 Route de test
app.get("/", (req, res) => {
  res.send("Backend de publication prêt à recevoir !");
});

// 📤 Route pour créer une publication
app.post("/api/post", async (req, res) => {
  const { imageUrl, description, username, avatar, timestamp } = req.body;

  if (!imageUrl || !description || !username || !timestamp) {
    return res.status(400).json({ error: "Données manquantes." });
  }

  const { data, error } = await supabase
    .from("posts")
    .insert([
      {
        image_url: imageUrl,
        description,
        username,
        avatar,
        created_at: timestamp,
        likes: 0,
        comment_count: 0,
      },
    ])
    .select("*");

  if (error) {
    console.error("Erreur Supabase :", error);
    return res.status(500).json({ error: "Erreur lors de l'enregistrement." });
  }

  res.status(201).json({ message: "Publication enregistrée", post: data[0] });
});

const PORT = process.routes.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🔥 Serveur démarré sur le port ${PORT}`);
});
// POST /api/post
app.post("/api/post", async (req, res) => {
  const { imageUrl, description, username, avatar, timestamp } = req.body;

  if (!imageUrl || !description || !username || !timestamp) {
    return res.status(400).json({ error: "Données manquantes." });
  }

  const { data, error } = await supabase
    .from("posts")
    .insert([
      {
        image_url: imageUrl,
        description,
        username,
        avatar,
        created_at: timestamp,
        likes: 0,
        comment_count: 0,
      },
    ])
    .select("*");

  if (error) {
    console.error("Erreur Supabase :", error);
    return res.status(500).json({ error: "Erreur lors de l'enregistrement." });
  }

  res.status(201).json({ message: "Publication enregistrée", post: data[0] });
});

app.listen(PORT, () => {
  console.log(` Backend opérationnel sur le port ${PORT}`);
});
