/**
 * Firebase Functions with Node.js 20 and v2 Firestore API
 */

const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotification =
 onDocumentCreated("chats/{chatId}/messages/{messageId}", async (event) => {
   console.log("Function triggered by a new message.");

   const snap = event.data;
   if (!snap) {
     console.log("ERROR: No data found in Firestore event");
     return;
   }

   const message = snap.data();
   const chatId = event.params.chatId;
   console.log("Extracted message data and chat ID.", {chatId, message});

   try {
     console.log(`Attempting to fetch chat document from 'chats/${chatId}'.`);
     //  const chatDoc = await
     //  admin.firestore().collection("chats").doc(chatId).get();

     //  if (!chatDoc.exists) {
     //    console.log(`ERROR: Chat document not found at 'chats/${chatId}'.
     //      Exiting function.`);
     //    return;
     //  }
     //  console.log("Successfully fetched chat document.");

     //  const users = chatDoc.data().users;
     //  if (!users || !Array.isArray(users)) {
     //    console.log("ERROR: 'users' array not found in chat document");
     //    return;
     //  }
     //  console.log("Extracted user IDs from chat document.", {users});

     const senderId = message.senderId;
     if (!senderId) {
       console.log("ERROR: Sender ID not found in message data");
       return;
     }
     console.log("Extracted sender ID.", {senderId});

     const receiverId = message.receiverId;
     if (!receiverId) {
       console.log("ERROR: Recipient ID not found in 'users' array");
       return;
     }
     console.log("Determined recipient ID.", {receiverId});

     console.log(`Attempting to fetch recipient's user document from '
      users/${receiverId}'.`);
     const recipientDoc = await admin.firestore()
         .collection("users").doc(receiverId).get();

     if (!recipientDoc.exists) {
       console.log(`ERROR: Recipient document not found at '
        users/${receiverId}'`);
       return;
     }
     console.log("Successfully fetched recipient document.", recipientDoc);

     const fcmToken = recipientDoc.data().fcmToken;
     if (!fcmToken) {
       console.log("ERROR: FCM token not found for recipient");
       return;
     }
     console.log("Extracted FCM token.", {fcmToken});

     console.log(`Attempting to fetch sender
      's user document from 'users/${senderId}'.`);
     const senderDoc = await admin.firestore()
         .collection("users").doc(senderId).get();
     const senderName = senderDoc.exists ?
      (senderDoc.data().firstName || senderId) : senderId;
     console.log("Determined sender's name.", {senderName});

     const payload = {
       notification: {
         title: `New Message from ${senderName}`,
         body: message.chatTextBody || "You have a new message",
         //  sound: "notification.mp3",
       },
       data: {
         chatId,
         type: "chat",
         senderId,
         receiverId,
       },
     };
     console.log("Constructed notification payload.", {payload});

     console.log("Attempting to send notification via FCM.");
     await admin.messaging().send({
       token: fcmToken,
       ...payload,
       android: {
         notification: {
           sound: "notification",
         },
       },
       apns: {
         payload: {
           aps: {
             sound: "notification.mp3",
           },
         },
       },
     });
     console.log("Notification sent successfully.");
   } catch (error) {
     console.error("An unexpected error occurred:", error);
   }
 });
