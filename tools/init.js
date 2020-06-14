const admin = require('firebase-admin');
const {deleteCollection} = require("./util")
const {data} = require("./data")

let serviceAccount = require('./tester-235ac-ce7e783dad47.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

let db = admin.firestore();

console.log("Delete all documents")
deleteCollection(db, "test", 10).then(() => {
    console.log("Deleted, adding documents")
    Promise.all(data.map(company => db.collection("test").add(company)))
        .then(() => {
            console.log("Done")
            db.collection('test').get()
                .then((snapshot) => {
                    snapshot.forEach((doc) => {
                        console.log(doc.id, '=>', doc.data());
                    });
                })
                .catch((err) => {
                    console.log('Error getting documents', err);
                });
        })
        .catch(e => console.error("Error creating documents", e))
});

