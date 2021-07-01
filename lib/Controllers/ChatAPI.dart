import 'package:chat_app/Models/Friend.dart';
import 'package:chat_app/Models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatAPI {
  Future<List<Friend>> getAllFriends(String uid) async {
    List<Friend> result = [];
    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      result.add(
        Friend.fromJson(
          doc.data(),
        ),
      );
    }
    return result;
  }

  Future<String> postMessage(
      String userId, String friendId, Message msg) async {
    msg.isMe = true;
    CollectionReference user = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .collection('messages');
    var response = await user
        .doc(msg.uid)
        .set(msg.toJson())
        .then((value) => null)
        .catchError((error) => error.toString());
    if (response != null) {
      return response.toString();
    }

    msg.isMe = false;
    user = FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .collection('messages');

    response = await user
        .doc(msg.uid)
        .set(msg.toJson())
        .then((value) => null)
        .catchError((error) => error.toString());

    if (response != null) {
      return response.toString();
    }
    return null;
  }
}
