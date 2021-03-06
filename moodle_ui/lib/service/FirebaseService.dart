import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseReference = Firestore.instance;

  FirebaseService();

  setFirebaseToken(String username) async {
    await _firebaseMessaging.getToken().then((token) async {
      var qsnapshot = await databaseReference
          .collection('DeviceTokens')
          .where('device_token', isEqualTo: token.toString())
          .getDocuments();

      if (qsnapshot.documents.length == 0) {
        DocumentReference ref =
            await databaseReference.collection("DeviceTokens").add({
          'device_token': '$token',
          'username': username,
        });

      } else {
        qsnapshot.documents.forEach((elem) {
          elem.reference.updateData(<String,dynamic>{
            'username':username
          });
        });
      }
    });
  }

  addFireBaseMessage(
      String messageText, String groupName, List<String> usernames) async {
    databaseReference.runTransaction((transaction) async {
      await transaction
          .set(Firestore.instance.collection("Messages").document(), {
        'message': messageText,
        'groupName': groupName,
        'ownerName': 'OWNER',
        'members': FieldValue.arrayUnion(usernames),
      });
    });
  }
}
