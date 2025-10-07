const express = require("express");
const router = express.Router();
const supabase = require("../supabaseClient");

// Route de test
router.get("/", (req, res) => {
  res.send("Backend de publication prêt à recevoir !");
});

// Créer une publication
router.post("/", async (req, res) => {
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

// Récupérer toutes les publications
router.get("/all", async (req, res) => {
  const { data, error } = await supabase
    .from("posts")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Erreur Supabase :", error);
    return res.status(500).json({ error: "Erreur lors de la récupération." });
  }

  res.status(200).json(data);
});

module.exports = router;
