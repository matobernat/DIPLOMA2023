const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.addGenderToClients = functions.https.onRequest(async (req, res) => {
  const db = admin.firestore();

  const clientsSnapshot = await db.collection("clients").get();
  const updates = [];

  clientsSnapshot.forEach((doc) => {
    updates.push(doc.ref.update({"gender": "Other"}));
  });

  await Promise.all(updates);

  res.send("Gender added to all clients");
});

// Use the following curl command to manually trigger this function:
// bernat@Martins-MacBook-Pro DIPLOMA2023 % firebase deploy --only functions
// curl https://us-central1-diploma-swift-app-bernat.cloudfunctions.net/updateAttribute
exports.updateAttribute = functions.https.onRequest(async (req, res) => {
  const db = admin.firestore();

  const collections = ["clients", "exercises", "mezocycles", "phases"];

  const updates = [];

  for (const collection of collections) {
    const snapshot = await db.collection(collection).get();

    snapshot.forEach((doc) => {
      const data = doc.data();

      if (Object.prototype.hasOwnProperty.call(data, "imageName")) {
        const imageName = data.imageName;
        updates.push(doc.ref.update({"placeholderName": imageName}));
      }
    });
  }

  await Promise.all(updates);

  res.send("Attribute updated successfully");
});

// Use the following curl command to manually trigger this function:
// curl https://us-central1-diploma-swift-app-bernat.cloudfunctions.net/swapIds
exports.swapIds = functions.https.onRequest(async (req, res) => {
  const db = admin.firestore();
  const collection = "categories";
  const updates = [];
  const snapshot = await db.collection(collection).get();

  snapshot.forEach((doc) => {
    const data = doc.data();
    if (data.dataType === "progressAlbum" && data.isGlobal === false) {
      const tempId = data.accountID;
      data.accountID = data.profileID;
      data.profileID = tempId;

      updates.push(
          doc.ref.update({
            "accountID": data.accountID,
            "profileID": data.profileID,
          }),
      );
    }
  });

  await Promise.all(updates);
  res.send("IDs swapped successfully");
});


// Use the following curl command to manually trigger this function:
// curl https://us-central1-diploma-swift-app-bernat.cloudfunctions.net/addMeasurements
// This is a new function to add measurements property
exports.addMeasurements = functions.https.onRequest(async (req, res) => {
  const db = admin.firestore();

  // Collection to update
  const collection = "clients";

  const updates = [];

  const snapshot = await db.collection(collection).get();

  snapshot.forEach((doc) => {
    // Adding empty measurements array
    updates.push(doc.ref.update({"measurements": []}));
  });

  await Promise.all(updates);

  res.send("Measurements added successfully");
});

npm install -g firebase-tools


npm install -g npm@10.1.0
