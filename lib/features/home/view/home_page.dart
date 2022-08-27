import 'package:contacts/app/bloc/app_bloc.dart';
import 'package:contacts/data/repositories/firestore_repository.dart';
import 'package:contacts/features/home/cubit/home_cubit.dart';
import 'package:contacts/features/home/widgets/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final uid = context.select((AppBloc bloc) => bloc.state.user!.uid);
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(
        context.read<FirestoreRepository>(),
      )..openHome(uid: uid),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = context.select((HomeCubit cubit) => cubit.state.contacts);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: ListView.builder(
          key: ValueKey('${contacts.length}'),
          itemCount: contacts.length,
          itemBuilder: (context, i) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  contacts[i].name.substring(0, 1).toUpperCase(),
                ),
              ),
              title: Text(contacts[i].name),
              subtitle: Text(contacts[i].number),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            AddContactPage.route(
              cubit: context.read<HomeCubit>(),
            ),
          );
        },
      ),
    );
  }
}
