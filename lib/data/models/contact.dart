import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  const Contact({
    required this.name,
    required this.number,
    this.snapshot,
    this.reference,
    this.documentID,
  });
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] as String,
      number: map['number'] as String,
    );
  }

  factory Contact.fromFirestore(DocumentSnapshot snapshot) {
    // ignore: cast_nullable_to_non_nullable
    final map = snapshot.data() as Map;

    return Contact(
      name: map['name'] as String,
      number: map['number'] as String,
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }
  final String name;
  final String number;
  final DocumentSnapshot? snapshot;
  final DocumentReference? reference;
  final String? documentID;

  Map<String, dynamic> toMap() => {
        'name': name,
        'number': number,
      };

  Contact copyWith({
    String? name,
    String? number,
  }) {
    return Contact(
      name: name ?? this.name,
      number: number ?? this.number,
    );
  }

  @override
  List<Object> get props {
    return [
      name,
      number,
    ];
  }
}
