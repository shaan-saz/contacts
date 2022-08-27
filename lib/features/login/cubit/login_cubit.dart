import 'package:bloc/bloc.dart';
import 'package:contacts/app/bloc/app_bloc.dart';
import 'package:contacts/data/models/user.dart';
import 'package:contacts/data/repositories/authentication_repository.dart';
import 'package:contacts/data/repositories/firestore_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthenticationRepository authenticationRepository,
    required FirestoreRepository firestoreRepository,
    required AppBloc appBloc,
  })  : _authenticationRepository = authenticationRepository,
        _firestoreRepository = firestoreRepository,
        _appBloc = appBloc,
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;
  final FirestoreRepository _firestoreRepository;
  final AppBloc _appBloc;

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final user = await _authenticationRepository.logInWithGoogle();
      final isProfileExist =
          await _firestoreRepository.isProfileExist(uid: user!.uid);
      if (!isProfileExist) {
        await _firestoreRepository.saveUser(
          user: UserData(
            name: user.displayName,
            email: user.email,
            uid: user.uid,
            photoURL: user.photoURL,
          ),
        );
      }
      // ignore: invalid_use_of_visible_for_testing_member
      _appBloc.add(AppUserChanged(user));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
