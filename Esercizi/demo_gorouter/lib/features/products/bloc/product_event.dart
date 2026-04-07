import 'package:equatable/equatable.dart';

/// Eventi per il Bloc dei prodotti.
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Evento per caricare tutti i prodotti
class ProductsLoadRequested extends ProductEvent {
  const ProductsLoadRequested();
}

/// Evento per filtrare i prodotti per categoria
class ProductsFilterByCategory extends ProductEvent {
  final String? category;

  const ProductsFilterByCategory({this.category});

  @override
  List<Object?> get props => [category];
}

/// Evento per cercare prodotti
class ProductsSearchRequested extends ProductEvent {
  final String query;

  const ProductsSearchRequested({required this.query});

  @override
  List<Object?> get props => [query];
}
