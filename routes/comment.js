const express = require("express");
const router = express.Router();
const supabase = require("../supabaseClient");

// Ajouter un commentaire
router.post("/", async (req, res) => {
  const { post_id, username, avatar, comment_text, timestamp } = req.body;

  if (!post_id || !username || !comment_text || !timestamp) {
    return res.status(400).json({ error: "Champs obligatoires manquants." });
  }

  const { data, error } = await supabase.from("comments").insert([
    {
      post_id,
      username,
      avatar,
      comment_text,
      created_at: timestamp,
      likes: 0,
    },
  ]).select("*");

  if (error) {
    console.error("Erreur Supabase (commentaire) :", error);
    return res.status(500).json({ error: "Impossible d’ajouter le commentaire." });
  }

  // Incrémenter le nombre de commentaires dans `posts`
  await supabase.rpc("increment_comment_count", { post_id_param: post_id });

  res.status(201).json({ message: "Commentaire ajouté", comment: data[0] });
});

module.exports = router;
