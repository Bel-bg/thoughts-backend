// sendNotifications.js

const fetch = require("node-fetch");
const supabase = require("./supabaseClient"); // Ton client Supabase déjà configuré

async function sendPushNotificationsToAllUsers(message) {
  // Récupère tous les tokens Expo enregistrés
  const { data: users, error } = await supabase.from("users").select("expo_token");

  if (error) {
    console.error(" Erreur lors de la récupération des tokens :", error);
    return;
  }

  // Filtrer les tokens valides
  const messages = users
    .filter((u) => u.expo_token && u.expo_token.startsWith("ExponentPushToken"))
    .map((u) => ({
      to: u.expo_token,
      sound: "default",
      title: "Nouvelle pensée",
      body: message,
      data: { screen: "NotesSection" },
    }));

  // Envoyer les messages à l'API d'Expo
  const chunks = [];
  const chunkSize = 100;
  for (let i = 0; i < messages.length; i += chunkSize) {
    chunks.push(messages.slice(i, i + chunkSize));
  }

  for (const chunk of chunks) {
    try {
      const res = await fetch("https://exp.host/--/api/v2/push/send", {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Accept-Encoding": "gzip, deflate",
          "Content-Type": "application/json",
        },
        body: JSON.stringify(chunk),
      });

      const responseData = await res.json();
      console.log("Résultat envoi Expo :", responseData);
    } catch (err) {
      console.error(" Erreur d'envoi Expo :", err);
    }
  }
}

module.exports = sendPushNotificationsToAllUsers;
