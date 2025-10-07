const express = require("express");
const router = express.Router();
const supabase = require("../supabaseClient");
const sendPushNotificationToAllUsers = require("../sendNotifications");

// Liker ou délker une thought
router.post("/thought", async (req, res) => {
  const { thought_id, user_id } = req.body;

  if (!thought_id || !user_id) {
    return res.status(400).json({ error: "thought_id et user_id requis." });
  }

  // Vérifier si le like existe déjà
  const { data: existingLike, error: checkError } = await supabase
    .from("thought_likes")
    .select("*")
    .eq("thought_id", thought_id)
    .eq("user_id", user_id)
    .single();

  if (checkError && checkError.code !== 'PGRST116') { // PGRST116 = no rows
    console.error("Erreur lors de la vérification du like :", checkError);
    return res.status(500).json({ error: "Erreur serveur." });
  }

  let isLiked = false;
  if (existingLike) {
    // Supprimer le like
    const { error: deleteError } = await supabase
      .from("thought_likes")
      .delete()
      .eq("thought_id", thought_id)
      .eq("user_id", user_id);

    if (deleteError) {
      console.error("Erreur lors de la suppression du like :", deleteError);
      return res.status(500).json({ error: "Erreur lors de la suppression." });
    }
  } else {
    // Ajouter le like
    const { error: insertError } = await supabase
      .from("thought_likes")
      .insert([{ thought_id, user_id }]);

    if (insertError) {
      console.error("Erreur lors de l'ajout du like :", insertError);
      return res.status(500).json({ error: "Erreur lors de l'ajout." });
    }
    isLiked = true;
  }

  // Compter les likes pour cette thought
  const { count, error: countError } = await supabase
    .from("thought_likes")
    .select("*", { count: 'exact', head: true })
    .eq("thought_id", thought_id);

  if (countError) {
    console.error("Erreur lors du comptage :", countError);
    return res.status(500).json({ error: "Erreur lors du comptage." });
  }

  // Mettre à jour le likes_count dans thoughts
  const { error: updateError } = await supabase
    .from("thoughts")
    .update({ likes_count: count })
    .eq("id", thought_id);

  if (updateError) {
    console.error("Erreur lors de la mise à jour :", updateError);
    return res.status(500).json({ error: "Erreur lors de la mise à jour." });
  }

  // Envoyer une notification si c'est un nouveau like
  if (isLiked) {
    try {
      // Récupérer les informations de la pensée pour la notification
      const { data: thoughtData } = await supabase
        .from("thoughts")
        .select("username, content")
        .eq("id", thought_id)
        .single();

      if (thoughtData) {
        const contentPreview = thoughtData.content.length > 50 
          ? thoughtData.content.substring(0, 50) + "..." 
          : thoughtData.content;
        
        await sendPushNotificationToAllUsers(
          `Nouvelle réaction sur la pensée de ${thoughtData.username}: "${contentPreview}"`
        );
      }
    } catch (err) {
      console.error("Erreur lors de l'envoi de la notification de like :", err);
      // Ne pas bloquer la réponse si la notification échoue
    }
  }

  res.status(200).json({ isLiked, likes_count: count });
});

module.exports = router;