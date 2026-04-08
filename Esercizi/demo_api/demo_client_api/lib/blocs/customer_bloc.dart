import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:demo_client_api/repositories/customer_repository.dart';
import '../models/customer_model.dart';
import 'package:equatable/equatable.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends HydratedBloc<CustomerEvent, CustomerState> {
  final CustomerRepository repository;

  CustomerBloc(this.repository) : super(CustomerLoading()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<AddCustomer>(_onAddCustomer);
    on<UpdateCustomer>(_onUpdateCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
  }

  void _onLoadCustomers(LoadCustomers event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final customers = await repository.fetchCustomers();
      emit(CustomerLoaded(customers));
    } catch (e) {
      emit(CustomerError());
    }
    /*
    } catch (_) {
      emit(CustomerError());
    }
    */
  }

  void _onAddCustomer(AddCustomer event, Emitter<CustomerState> emit) async {
    if (state is CustomerLoaded) {
      await repository.addCustomer(event.customer);
      add(LoadCustomers());
    }
  }

  void _onUpdateCustomer(UpdateCustomer event, Emitter<CustomerState> emit) async {
    if (state is CustomerLoaded) {
      await repository.updateCustomer(event.customer);
      add(LoadCustomers());
    }
  }

  void _onDeleteCustomer(DeleteCustomer event, Emitter<CustomerState> emit) async {
    if (state is CustomerLoaded) {
      await repository.deleteCustomer(event.id);
      add(LoadCustomers());
    }
  }

  @override
  CustomerState? fromJson(Map<String, dynamic> json) => CustomerLoaded(
      (json['customers'] as List).map((e) => Customer.fromJson(e)).toList());

  @override
  Map<String, dynamic>? toJson(CustomerState state) =>
      state is CustomerLoaded ? {'customers': state.customers.map((c) => c.toJson()).toList()} : null;
}
