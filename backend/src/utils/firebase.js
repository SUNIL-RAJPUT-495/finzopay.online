import admin from "firebase-admin";
import fs from "fs";

const serviceAccount = JSON.parse(
    fs.readFileSync("./firebase-service-account.json", "utf8")
);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

export default admin;


// 📌 firebase-service-account.json
// Firebase console → Project Settings → Service Accounts → Generate key