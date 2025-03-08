const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.getAllUsers = functions.https.onRequest(async (req, res) => {
    try {
        const listUsersResult = await admin.auth().listUsers(100); // Fetch first 100 users
        const users = listUsersResult.users.map(user => ({
            uid: user.uid,
            email: user.email,
            // displayName: user.displayName
        }));

        res.status(200).json(users);
    } catch (error) {
        console.error("Error fetching users:", error);
        res.status(500).json({ error: error.message });
    }
});
