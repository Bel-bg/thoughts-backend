const express = require("express");
const cors = require("cors");
const supabase = require("./supabaseClient");
const postRoutes = require("./routes/Post");
const commentRoutes = require("./routes/comment");
const likeRoutes = require("./routes/like");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;
const sendPushNotificationToAllUsers = require("./sendNotifications");

app.use(cors());
app.use(express.json());

app.use("/api/comment", commentRoutes);
app.use("/api/posts", postRoutes);
app.use("/api/like", likeRoutes);

// Publier une pensée
app.post("/post-thought", async (req, res) => {
  const { username, avatar_url, content } = req.body;

  if (!content || content.length > 500) {
    return res.status(400).json({ error: "Pensée trop longue (max 500 caractères) ou vide" });
  }

  if (content.trim().length === 0) {
    return res.status(400).json({ error: "La pensée ne peut pas être vide" });
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

  try {
    await sendPushNotificationToAllUsers(
      `${username} a publié une nouvelle pensée`
    );
  } catch (err) {
    console.error("Erreur lors de l'envoi de la notification :", err);
  }

  res.status(201).json(data[0]);
});

// Récupérer les pensées valides avec comptage des likes en temps réel
app.get("/thoughts", async (req, res) => {
  const user_id = req.query.user_id; // Optionnel pour vérifier si liké

  try {
    // Récupérer les pensées avec comptage des likes
    const { data, error } = await supabase
      .from("thoughts")
      .select(`
        *,
        thought_likes(count)
      `)
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Erreur lors de la récupération des pensées:", error);
      return res.status(500).json({ error: error.message });
    }

    // Enrichir les données avec le comptage des likes en temps réel
    const enrichedData = await Promise.all(
      data.map(async (thought) => {
        // Compter les likes en temps réel
        const { count, error: countError } = await supabase
          .from("thought_likes")
          .select("*", { count: "exact", head: true })
          .eq("thought_id", thought.id);

        if (countError) {
          console.error("Erreur comptage likes:", countError);
        }

        // Vérifier si l'utilisateur a liké cette pensée
        let isLiked = false;
        if (user_id) {
          const { data: likeData, error: likeError } = await supabase
            .from("thought_likes")
            .select("*")
            .eq("thought_id", thought.id)
            .eq("user_id", user_id)
            .maybeSingle();

          if (!likeError && likeData) {
            isLiked = true;
          }
        }

        return {
          ...thought,
          likes_count: count || 0,
          isLiked: isLiked,
        };
      })
    );

    res.json(enrichedData);
  } catch (error) {
    console.error("Erreur serveur:", error);
    res.status(500).json({ error: "Erreur serveur lors de la récupération des pensées" });
  }
});

app.listen(PORT, () =>
  console.log(`🚀 Serveur lancé sur http://localhost:${PORT}`)
);

// Lancement du nettoyage automatique
require("./removeExpired");
