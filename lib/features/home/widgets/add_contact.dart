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
                          contact: Contact(
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
                MaskedTextField(
                  maskedTextFieldController: _cPhoneNumber,
                  mask: '(xx) xxxxx-xxxx',
                  maxLength: 16,
                  keyboardType: TextInputType.phone,
                  inputDecoration: const InputDecoration(
                    labelText: 'Phone',
                    icon: Icon(Icons.phone),
                  ),
                  onChange: (value) => print,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MaskedTextField extends StatefulWidget {
  const MaskedTextField({
    required this.mask,
    this.escapeCharacter = 'x',
    required this.maskedTextFieldController,
    this.maxLength = 100,
    this.keyboardType = TextInputType.text,
    this.inputDecoration = const InputDecoration(),
    this.focusNode,
    required this.onChange,
    super.key,
  });
  final TextEditingController maskedTextFieldController;

  final String mask;
  final String escapeCharacter;

  final int maxLength;
  final TextInputType keyboardType;
  final InputDecoration inputDecoration;
  final FocusNode? focusNode;

  final ValueChanged<String> onChange;

  @override
  State<StatefulWidget> createState() => _MaskedTextFieldState();
}

class _MaskedTextFieldState extends State<MaskedTextField> {
  @override
  Widget build(BuildContext context) {
    var lastTextSize = 0;

    return TextField(
      controller: widget.maskedTextFieldController,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      decoration: widget.inputDecoration,
      focusNode: widget.focusNode,
      onChanged: (String text) {
        if (text.length < lastTextSize) {
          if (widget.mask[text.length] != widget.escapeCharacter) {
            widget.maskedTextFieldController.selection =
                TextSelection.fromPosition(
              TextPosition(
                offset: widget.maskedTextFieldController.text.length,
              ),
            );
          }
        } else {
          if (text.length >= lastTextSize) {
            final position = text.length;

            if ((widget.mask[position - 1] != widget.escapeCharacter) &&
                (text[position - 1] != widget.mask[position - 1])) {
              widget.maskedTextFieldController.text = _buildText(text);
            }

            if (widget.mask[position] != widget.escapeCharacter) {
              widget.maskedTextFieldController.text =
                  '${widget.maskedTextFieldController.text}${widget.mask[position]}';
            }
          }

          if (widget.maskedTextFieldController.selection.start <
              widget.maskedTextFieldController.text.length) {
            widget.maskedTextFieldController.selection =
                TextSelection.fromPosition(
              TextPosition(
                offset: widget.maskedTextFieldController.text.length,
              ),
            );
          }
        }

        lastTextSize = widget.maskedTextFieldController.text.length;

        widget.onChange(widget.maskedTextFieldController.text);
      },
    );
  }

  String _buildText(String text) {
    var result = '';

    for (var i = 0; i < text.length - 1; i++) {
      result += text[i];
    }

    result += widget.mask[text.length - 1];
    result += text[text.length - 1];

    return result;
  }
}
