import 'package:contacts/app/view/app.dart';
import 'package:contacts/bootstrap.dart';
import 'package:contacts/data/repositories/authentication_repository.dart';
import 'package:contacts/data/repositories/firestore_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenticationRepository = AuthenticationRepository();
  final firestoreRepository = FirestoreRepository();
  await bootstrap(
    () => App(
      authenticationRepository: authenticationRepository,
      firestoreRepository: firestoreRepository,
    ),
  );
}
