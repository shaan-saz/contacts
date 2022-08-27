import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/data/models/contact.dart';
import 'package:contacts/data/models/user.dart';

class FirestoreRepository {
  FirestoreRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<void> saveUser({
    required UserData user,
  }) async {
    final saveUserWriteBatch = _firebaseFirestore.batch();
    final userReference = _firebaseFirestore.collection('users').doc(user.uid);

    saveUserWriteBatch.set(
      userReference,
      user.toMap(),
      SetOptions(merge: true),
    );
    await saveUserWriteBatch.commit();
  }

  Future<bool> isUsernameExist({
    required String username,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> isProfileExist({
    required String uid,
  }) async {
    final snapshot =
        await _firebaseFirestore.collection('users').doc(uid).get();

    final isProfileComplete = snapshot.exists &&
        snapshot.data()!.containsKey('uid') &&
        snapshot.data()!.containsKey('photoURL') &&
        snapshot.data()!.containsKey('name') &&
        snapshot.data()!.containsKey('email');
    return isProfileComplete;
  }

  Future<void> saveContact({
    required Contact contact,
    required String uid,
  }) async {
    await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .add(contact.toMap());
  }

  Future<void> updateContact({
    required Contact contact,
    required String uid,
  }) async {
    final updateContactWriteBatch = _firebaseFirestore.batch();
    final contactReference = _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .doc(contact.documentID);

    updateContactWriteBatch.update(
      contactReference,
      contact.toMap(),
    );
    await updateContactWriteBatch.commit();
  }

  Stream<List<Contact>> fetchContacts({required String uid}) {
    final contactsReference = _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .snapshots()
        .map((event) => event.docs.map(Contact.fromFirestore).toList());
    return contactsReference;
  }
}
