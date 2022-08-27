import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts/data/models/contact.dart';
import 'package:contacts/data/repositories/firestore_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._firestoreRepository) : super(const HomeState());

  final FirestoreRepository _firestoreRepository;
  StreamSubscription<List<Contact>>? contactsSubscription;

  Future<void> openHome({required String uid}) async {
    emit(const HomeState(status: HomeStatus.loading));
    try {
      await contactsSubscription?.cancel();
      final contactsStream = _firestoreRepository.fetchContacts(uid: uid);
      contactsSubscription = contactsStream.listen(
        (contacts) {
          emit(
            HomeState(status: HomeStatus.success, contacts: contacts),
          );
        },
      );
    } catch (e) {
      emit(const HomeState(status: HomeStatus.failure));
    }
  }

  Future<void> saveContact({
    required Contact contact,
    required String uid,
  }) async {
    await _firestoreRepository.saveContact(contact: contact, uid: uid);
  }

  Future<void> updateContact({
    required Contact contact,
    required String uid,
  }) async {
    await _firestoreRepository.updateContact(contact: contact, uid: uid);
  }

  @override
  Future<void> close() async {
    await contactsSubscription?.cancel();
    return super.close();
  }
}
