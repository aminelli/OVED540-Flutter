import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/customer_bloc.dart';
import '../models/customer_model.dart';

class CustomerForm extends StatefulWidget {
  final Customer? customer;

  const CustomerForm({super.key, this.customer});

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late String name, email;

  @override
  void initState() {
    super.initState();
    name = widget.customer?.name ?? '';
    email = widget.customer?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CustomerBloc>();
    return AlertDialog(
      title: Text(widget.customer == null ? 'Aggiungi Customer' : 'Modifica Customer'),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            initialValue: name,
            decoration: InputDecoration(labelText: 'Nome'),
            onChanged: (val) => name = val,
            validator: (val) => val!.isEmpty ? 'Obbligatorio' : null,
          ),
          TextFormField(
            initialValue: email,
            decoration: InputDecoration(labelText: 'Email'),
            onChanged: (val) => email = val,
            validator: (val) => val!.isEmpty ? 'Obbligatorio' : null,
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Annulla')),
        TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newCustomer = Customer(
                    id: widget.customer?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    email: email);
                widget.customer == null
                    ? bloc.add(AddCustomer(newCustomer))
                    : bloc.add(UpdateCustomer(newCustomer));
                Navigator.pop(context);
              }
            },
            child: Text('Salva')),
      ],
    );
  }
}
