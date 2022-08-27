import 'package:contacts/app/bloc/app_bloc.dart';
import 'package:contacts/data/models/contact.dart';
import 'package:contacts/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage._({required this.contact});

  final Contact? contact;

  static Route<void> route({
    required HomeCubit cubit,
    Contact? contact,
  }) =>
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return BlocProvider.value(
            value: cubit,
            child: AddContactPage._(
              contact: contact,
            ),
          );
        },
      );

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _cName;
  late TextEditingController _cPhoneNumber;

  @override
  void initState() {
    if (widget.contact != null) {
      _cName = TextEditingController(text: widget.contact?.name);
      _cPhoneNumber = TextEditingController(text: widget.contact?.number);
    } else {
      _cName = TextEditingController();
      _cPhoneNumber = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.select((AppBloc bloc) => bloc.state.user!.uid);
    final isEditing = widget.contact != null;
    return Scaffold(
      appBar: AppBar(
        title: isEditing
            ? const Text('Update Contact')
            : const Text('Add Contact'),
        actions: <Widget>[
          SizedBox(
            width: 80,
            child: IconButton(
              icon: Text(
                isEditing ? 'Update' : 'Save',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (isEditing) {
                    context.read<HomeCubit>().updateContact(
                          contact: widget.contact!.copyWith(
                            name: _cName.text,
                            number: _cPhoneNumber.text,
                          ),
                          uid: uid,
                        );
                  } else {
                    context.read<HomeCubit>().saveContact(
                          contact: Contact(
                            name: _cName.text,
                            number: _cPhoneNumber.text,
                          ),
                          uid: uid,
                        );
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _cName,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(45),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value != null && value.trim().isEmpty) {
                      return 'Text empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cPhoneNumber,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    icon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value != null && value.trim().isEmpty) {
                      return 'Text empty';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
