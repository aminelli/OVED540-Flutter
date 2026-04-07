import 'package:equatable/equatable.dart';
import '../../../models/product.dart';

/// Stati per il Bloc dei prodotti.
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Stato iniziale
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Caricamento prodotti in corso
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Prodotti caricati con successo
class ProductLoaded extends ProductState {
  final List<Product> products;
  final String? currentCategory;
  final String? searchQuery;

  const ProductLoaded({
    required this.products,
    this.currentCategory,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [products, currentCategory, searchQuery];
}

/// Errore durante il caricamento
class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}
