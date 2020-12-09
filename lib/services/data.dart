import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  getUserByUsername(String username) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        // ignore: deprecated_member_use
        .getDocuments();
  }

  userUploader(userMapping) {
    FirebaseFirestore.instance.collection("users").add(userMapping);
  }

  createChat(String chatid, data) {
    FirebaseFirestore.instance
        .collection("chat")
        .document(chatid)
        .setData(data)
        .catchError((e) {
      print(e);
    });
  }

  getUserByEmail(String email) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        // ignore: deprecated_member_use
        .getDocuments();
  }

  sendMessages(String id, messageObj) {
    FirebaseFirestore.instance
        .collection("chat")
        .document(id)
        .collection("chats")
        .add(messageObj)
        .catchError((e) {
      print(e);
    });
  }

  getMessages(String id) {
    return FirebaseFirestore.instance
        .collection("chat")
        .document(id)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getAllChatsToWhomTalk(String username) {
    return FirebaseFirestore.instance
        .collection("chat")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
