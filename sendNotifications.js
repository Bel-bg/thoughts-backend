const fetch = require("node-fetch");
const supabase = require("./supabaseClient");

async function sendPushNotificationToAllUsers(messageBody) {
  const { data: users, error } = await supabase
    .from("users")
    .select("expo_token");

  if (error) {
    console.log("Erreur de récupération des tokens", error);
    return;
  }

  const notifications = users
    .filter((u) => u.expo_token && u.expo_token.startsWith("ExponentPushToken"))
    .map((u) => ({
      to: u.expo_token,
      sound: "default",
      title: "Nouvelle pensée",
      body: messageBody,
      data: { screen: "NotesSection" },
    }));

  const chunks = [];
  const chunkSize = 100;
  for (let i = 0; i < notifications.length; i += chunkSize) {
    chunks.push(notifications.slice(i, i + chunkSize));
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
      console.log("Notification envoyée:", responseData);
    } catch (err) {
      console.error("Erreur d'envoi", err);
    }
  }
}

module.exports = sendPushNotificationToAllUsers;
