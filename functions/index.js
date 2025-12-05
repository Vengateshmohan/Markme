const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Load service account
const serviceAccount = require("./service-account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Callable function for sending FCM notification
exports.sendNotification = functions.https.onCall(async (data, context) => {
  const token = data.token;
  const title = data.title;
  const body = data.body;

  const message = {
    token: token,
    notification: {
      title: title,
      body: body,
    },
    android: {
      priority: "high",
    }
  };

  try {
    await admin.messaging().send(message);
    return { success: true };
  } catch (error) {
    return { success: false, error: error.toString() };
  }
});
