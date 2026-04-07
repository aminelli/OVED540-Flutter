import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/product.dart';

/// Pagina di dettaglio di un singolo prodotto.
/// 
/// Riceve l'ID del prodotto come parametro dalla route
/// e mostra le informazioni complete.
class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    // Recupera il prodotto dai dati di esempio
    final product = Product.findById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prodotto non trovato')),
        body: const Center(
          child: Text('Il prodotto richiesto non esiste'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine principale
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.grey.shade200,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image_not_supported, size: 64),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '€${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Categoria
                  Row(
                    children: [
                      const Icon(Icons.category, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Categoria: ${product.category}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Disponibilità
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: product.inStock
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: product.inStock
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          product.inStock
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: product.inStock
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product.inStock
                              ? 'Disponibile in magazzino'
                              : 'Non disponibile',
                          style: TextStyle(
                            color: product.inStock
                                ? Colors.green.shade900
                                : Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Descrizione
                  const Text(
                    'Descrizione',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Informazioni aggiuntive (demo)
                  const Text(
                    'Informazioni aggiuntive',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('ID Prodotto', productId),
                  _buildInfoRow('Spedizione', 'Gratuita per ordini sopra €50'),
                  _buildInfoRow('Resi', 'Reso gratuito entro 30 giorni'),
                  const SizedBox(height: 32),
                  
                  // Pulsanti azione
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: product.inStock
                              ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Prodotto aggiunto al carrello'),
                                    ),
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Aggiungi al carrello'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Aggiunto ai preferiti'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.favorite_border),
                        iconSize: 28,
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
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

}
