import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/order.dart';
import '../../../router/routes.dart';

/// Pagina che mostra la lista degli ordini dell'utente.
/// 
/// Dimostra l'uso di route annidate navigando ai dettagli degli ordini.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Order.getSampleOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('I Miei Ordini'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64),
                  SizedBox(height: 16),
                  Text('Nessun ordine effettuato'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      // Naviga ai dettagli dell'ordine (route annidata)
                      context.go(AppRoutes.orderDetailsPath(order.id));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ID e stato
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ordine #${order.id}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildStatusChip(order.status, order.statusText),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Data ordine
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(order.orderDate),
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Numero prodotti
                          Row(
                            children: [
                              const Icon(Icons.shopping_bag, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '${order.products.length} prodotto${order.products.length > 1 ? 'i' : ''}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Totale
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Totale',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '€${order.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
