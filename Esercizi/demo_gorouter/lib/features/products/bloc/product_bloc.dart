import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

/// Bloc per la gestione dei prodotti.
/// 
/// Gestisce il caricamento, la ricerca e il filtraggio dei prodotti.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  
  ProductBloc() : super(const ProductInitial()) {
    on<ProductsLoadRequested>(_onLoadRequested);
    on<ProductsFilterByCategory>(_onFilterByCategory);
    on<ProductsSearchRequested>(_onSearchRequested);
  }

  /// Carica tutti i prodotti
  Future<void> _onLoadRequested(
    ProductsLoadRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    
    try {
      // Simula caricamento da API
      await Future.delayed(const Duration(milliseconds: 800));
      
      final products = Product.getSampleProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: 'Errore nel caricamento dei prodotti: ${e.toString()}'));
    }
  }

  /// Filtra i prodotti per categoria
  Future<void> _onFilterByCategory(
    ProductsFilterByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final allProducts = Product.getSampleProducts();
      
      final filteredProducts = event.category == null || event.category!.isEmpty
          ? allProducts
          : allProducts.where((p) => p.category == event.category).toList();
      
      emit(ProductLoaded(
        products: filteredProducts,
        currentCategory: event.category,
      ));
    } catch (e) {
      emit(ProductError(message: 'Errore nel filtraggio: ${e.toString()}'));
    }
  }

  /// Cerca prodotti per nome o descrizione
  Future<void> _onSearchRequested(
    ProductsSearchRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final allProducts = Product.getSampleProducts();
      final query = event.query.toLowerCase();
      
      final filteredProducts = allProducts.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query);
      }).toList();
      
      emit(ProductLoaded(
        products: filteredProducts,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(ProductError(message: 'Errore nella ricerca: ${e.toString()}'));
    }
  }

}
