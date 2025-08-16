/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.sendChatNotification = functions.firestore
    .document("chats/{chatId}/messages/{messageId}")
    .onCreate(async (snap, context) => {
      const message = snap.data();
      const chatId = context.params.chatId;
      // Get the user IDs from the chat document
      // This assumes your chat document has a 'users' array field
      const chatDoc = await admin.firestore()
          .collection("chats")
          .doc(chatId).get();
      const users = chatDoc.data().users;
      const senderId = message.auther.id;
      // Get the recipient's ID.
      const recipientId = users.find((id) => id !== senderId);
      if (!recipientId) {
        console.log("Recipient not found");
        return;
      }
      // Get the recipient's user document to find their FCM token
      const recipientDoc = await admin.firestore()
          .collection("users")
          .doc(recipientId)
          .get();
      const fcmToken = recipientDoc.data().fcmToken;
      if (!fcmToken) {
        console.log("FCM token not found for recipient");
        return;
      }
      // Get the sender's name
      const senderDoc = await admin
          .firestore()
          .collection("users")
          .doc(senderId)
          .get();
      const senderName = senderDoc.data().firstName || "New message";
      // Construct the notification message
      const payload = {
        notification: {
          title: `New Message from ${senderName}`,
          body: message.text,
          sound: "notification.mp3",
        },
        data: {
          chatId: chatId,
          type: "chat",
          senderId: senderId,
          // TODO:handle when user click on the notification what will happen
        },
      };
      try {
        await admin.messaging().send({
          token: fcmToken,
          ...payload,
          android: {
            notification: {
              sound: "notification", // no extension for android
            },
          },
          apns: {
            payload: {
              aps: {
                sound: "notification.mp3", // iOs usually requires full name
              },
            },
          },
        });
        console.log("Notification send Successfully with custom sound");
      } catch (error) {
        console.log("Error sending notification:", error);
      }
    });
