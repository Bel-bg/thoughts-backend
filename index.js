const express = require("express");
const cors = require("cors");
const supabase = require("./supabaseClient");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Publier une pensée
app.post("/post-thought", async (req, res) => {
  const { username, avatar_url, content } = req.body;

  if (!content || content.length > 60) {
    return res.status(400).json({ error: "Pensée trop longue ou vide" });
  }

  const { data, error } = await supabase
    .from("thoughts")
    .insert([
      {
        username,
        avatar_url,
        content,
        created_at: new Date().toISOString(),
      },
    ])
    .select();

  if (error) {
    console.error("Ce n'est pas vôtre faute c'est la nôtre :", error.message);
    return res.status(500).json({ error: error.message });
  }

  res.status(201).json(data[0]);
});

// Récupérer les pensées valides
app.get("/thoughts", async (req, res) => {
  const { data, error } = await supabase
    .from("thoughts")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) return res.status(500).json({ error });
  res.json(data);
});

app.listen(PORT, () =>
  console.log(`🚀 Serveur lancé sur http://localhost:${PORT}`)
);

// Lancement du nettoyage automatique
require("./removeExpired");
