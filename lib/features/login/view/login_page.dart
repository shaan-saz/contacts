import 'package:contacts/app/bloc/app_bloc.dart';
import 'package:contacts/data/repositories/authentication_repository.dart';
import 'package:contacts/data/repositories/firestore_repository.dart';
import 'package:contacts/features/login/cubit/login_cubit.dart';
import 'package:contacts/features/login/view/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginCubit(
            authenticationRepository: context.read<AuthenticationRepository>(),
            firestoreRepository: context.read<FirestoreRepository>(),
            appBloc: context.read<AppBloc>(),
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
