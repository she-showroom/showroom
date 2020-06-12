import {Elm} from "./elm/Main.elm"

import * as firebase from "firebase/app";
import "firebase/firestore";
import {firebaseConfig} from "./firebase"
firebase.initializeApp(firebaseConfig);
var db = firebase.firestore();

const app = Elm.Main.init({})

app.ports.getCards.subscribe(() => {
    db.collection("test").get().then((querySnapshot) => {
        const pages = []
        querySnapshot.forEach((doc) => {
            console.log(`${doc.id} => ${doc.data()}`);
            // pages[doc.id] = doc.data() as Test
            let page = doc.data()
            console.log("Page",page,"ID",doc.id)
            page["id"] = doc.id
            pages.push(page)
        });
        console.log("Send pages", pages)
        app.ports.cardsReceiver.send(pages)
    })
})

app.ports.saveCard.subscribe(card => {
    console.log("Save", JSON.stringify(card, null, 2))
    db.collection("test").add(card).then(() => {
        app.ports.cardSaved.send({success:true, message:""})
    }).catch(e => {
        app.ports.cardSaved.send({success:false, message:e})
    })
})
