part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;
  CustomerLoaded(this.customers);
  @override
  List<Object?> get props => [customers];
}

class CustomerError extends CustomerState {}
