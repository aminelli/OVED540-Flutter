import 'package:equatable/equatable.dart';
import 'product.dart';

/// Stato di un ordine
enum OrderStatus {
  pending,     // In attesa
  processing,  // In elaborazione
  shipped,     // Spedito
  delivered,   // Consegnato
  cancelled,   // Annullato
}

/// Modello che rappresenta un ordine effettuato dall'utente.
class Order extends Equatable {
  final String id;
  final List<Product> products;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  const Order({
    required this.id,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
  });

  @override
  List<Object?> get props => [id, products, totalAmount, status, orderDate, deliveryDate];

  /// Restituisce una descrizione testuale dello stato
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'In Attesa';
      case OrderStatus.processing:
        return 'In Elaborazione';
      case OrderStatus.shipped:
        return 'Spedito';
      case OrderStatus.delivered:
        return 'Consegnato';
      case OrderStatus.cancelled:
        return 'Annullato';
    }
  }

  /// Lista di ordini di esempio per la demo
  static List<Order> getSampleOrders() {
    final products = Product.getSampleProducts();
    
    return [
      Order(
        id: 'ORD001',
        products: [products[0], products[2]],
        totalAmount: 69.98,
        status: OrderStatus.delivered,
        orderDate: DateTime.now().subtract(const Duration(days: 10)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Order(
        id: 'ORD002',
        products: [products[1]],
        totalAmount: 89.99,
        status: OrderStatus.shipped,
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Order(
        id: 'ORD003',
        products: [products[3], products[5]],
        totalAmount: 184.98,
        status: OrderStatus.processing,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  /// Trova un ordine per ID
  static Order? findById(String id) {
    try {
      return getSampleOrders().firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  
}
