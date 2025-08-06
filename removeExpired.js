const cron = require("node-cron");
const supabase = require("./supabaseClient");

// Toutes les 15min, les pensées de plus de 24h seront supprimé

cron.schedule("*/15 * * * * ", async () => {
  const oneDayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();

  const { data, error } = await supabase
    .from("thoughts")
    .delete()
    .lt("created_at", oneDayAgo);

  if (error) {
    console.error("Erreur suppression pensées expirées:", error);
  } else {
    console.log("✅ Les pensées expirées ont été supprimées."); 
  }
});
