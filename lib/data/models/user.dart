import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  const UserData({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoURL,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory UserData.fromFirestore(DocumentSnapshot snapshot) {
    // ignore: cast_nullable_to_non_nullable
    final map = snapshot.data() as Map;

    return UserData(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoURL: map['photoURL'] as String,
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  Map<String, Object?> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoURL': photoURL,
      };

  UserData copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoURL,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  final String? uid;
  final String? name;
  final String? email;
  final String? photoURL;
  final DocumentSnapshot? snapshot;
  final DocumentReference? reference;
  final String? documentID;

  @override
  List<Object?> get props => [uid, name, email, photoURL];
}
