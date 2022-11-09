import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constants.dart';

class User {
  final String email;
  final String uid;
  String profilePic;
  final String username;
  final List connecting;
  final List connections;

  User(
      {required this.profilePic,
      required this.uid,
      required this.username,
      required this.connecting,
      required this.connections,
      required this.email});

  Map<String, dynamic> toJson() => {
        "profilePic": profilePic,
        "username": username,
        "email": email,
        "uid": uid,
        "connecting": connecting,
        "connections": connections,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      profilePic: snapshot['profilePic'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      connecting: snapshot['connecting'],
      connections: snapshot['connections'],
    );
  }

  static Future<User> fromUid(String uid) async {
    var snap = await firebaseFirestore.collection('users').doc(uid).get();
    return User.fromSnap(snap);
  }
}
