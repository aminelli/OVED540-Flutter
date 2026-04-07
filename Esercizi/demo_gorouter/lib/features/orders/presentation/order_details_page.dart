import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/order.dart';

/// Pagina di dettaglio di un singolo ordine.
/// 
/// Riceve l'ID dell'ordine come parametro dalla route annidata
/// e mostra le informazioni complete.
class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    // Recupera l'ordine dai dati di esempio
    final order = Order.findById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ordine non trovato')),
        body: const Center(
          child: Text('L\'ordine richiesto non esiste'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ordine #${order.id}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stato ordine
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Stato Ordine',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildStatusChip(order.status, order.statusText),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Data Ordine', _formatDate(order.orderDate)),
                    if (order.deliveryDate != null)
                      _buildInfoRow('Data Consegna', _formatDate(order.deliveryDate!)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Prodotti nell'ordine
            const Text(
              'Prodotti',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...order.products.map((product) {
              return Card(
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    ),
                  ),
                  title: Text(product.name),
                  subtitle: Text(product.category),
                  trailing: Text(
                    '€${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            
            // Riepilogo costi
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildCostRow('Subtotale', order.totalAmount),
                    const Divider(),
                    _buildCostRow('Spedizione', 0.0),
                    const Divider(),
                    _buildCostRow(
                      'Totale',
                      order.totalAmount,
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Pulsanti azione (demo)
            if (order.status != OrderStatus.delivered &&
                order.status != OrderStatus.cancelled)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tracciamento ordine non disponibile in questa demo'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.local_shipping),
                  label: const Text('Traccia spedizione'),
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Supporto non disponibile in questa demo'),
                    ),
                  );
                },
                icon: const Icon(Icons.help_outline),
                label: const Text('Contatta supporto'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status, String text) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        break;
      case OrderStatus.shipped:
        color = Colors.purple;
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        break;
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '€${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu',
      'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

}
