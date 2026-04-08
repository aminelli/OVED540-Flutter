part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomerEvent {}

class AddCustomer extends CustomerEvent {
  final Customer customer;
  AddCustomer(this.customer);
  @override
  List<Object?> get props => [customer];
}

class UpdateCustomer extends CustomerEvent {
  final Customer customer;
  UpdateCustomer(this.customer);
  @override
  List<Object?> get props => [customer];
}

class DeleteCustomer extends CustomerEvent {
  final String id;
  DeleteCustomer(this.id);
  @override
  List<Object?> get props => [id];
}
