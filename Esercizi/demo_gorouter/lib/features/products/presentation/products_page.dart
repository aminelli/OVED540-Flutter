import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../router/routes.dart';

/// Pagina che mostra la lista dei prodotti disponibili.
/// 
/// Utilizza ProductBloc per gestire il caricamento e il filtraggio.
/// Ogni prodotto è cliccabile e naviga alla pagina di dettaglio.
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    // Carica i prodotti all'avvio
    context.read<ProductBloc>().add(const ProductsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prodotti'),
        actions: [
          // Pulsante per filtrare
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (category) {
              context.read<ProductBloc>().add(
                    ProductsFilterByCategory(
                      category: category == 'Tutti' ? null : category,
                    ),
                  );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Tutti', child: Text('Tutti')),
              const PopupMenuItem(value: 'Libri', child: Text('Libri')),
              const PopupMenuItem(value: 'Elettronica', child: Text('Elettronica')),
              const PopupMenuItem(value: 'Audio', child: Text('Audio')),
              const PopupMenuItem(value: 'Accessori', child: Text('Accessori')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const LoadingWidget(message: 'Caricamento prodotti...');
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(const ProductsLoadRequested());
                    },
                    child: const Text('Riprova'),
                  ),
                ],
              ),
            );
          }

          if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text('Nessun prodotto trovato'),
              );
            }

            return Column(
              children: [
                // Mostra filtro attivo
                if (state.currentCategory != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.blue.shade50,
                    child: Row(
                      children: [
                        const Icon(Icons.filter_alt, size: 20),
                        const SizedBox(width: 8),
                        Text('Categoria: ${state.currentCategory}'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            context.read<ProductBloc>().add(
                                  const ProductsFilterByCategory(category: null),
                                );
                          },
                          child: const Text('Rimuovi filtro'),
                        ),
                      ],
                    ),
                  ),
                
                // Lista prodotti
                Expanded(
                  child: ListView.builder(
                    itemCount: state.products.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            // Naviga ai dettagli usando GoRouter
                            context.go(AppRoutes.productDetailsPath(product.id));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Immagine prodotto
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  color: Colors.grey.shade200,
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.image_not_supported),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nome e prezzo
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '€${product.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Categoria
                                    Chip(
                                      label: Text(product.category),
                                      labelStyle: const TextStyle(fontSize: 12),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Descrizione
                                    Text(
                                      product.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Disponibilità
                                    Row(
                                      children: [
                                        Icon(
                                          product.inStock
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          size: 16,
                                          color: product.inStock
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          product.inStock
                                              ? 'Disponibile'
                                              : 'Non disponibile',
                                          style: TextStyle(
                                            color: product.inStock
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Carica i prodotti'));
        },
      ),
    );
  }
}
