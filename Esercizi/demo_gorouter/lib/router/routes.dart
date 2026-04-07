/// Definizione delle costanti per le routes dell'applicazione.
/// 
/// Questo file centralizza tutte le route paths per evitare hard-coded strings
/// e facilitare la manutenzione del routing.
class AppRoutes {
  // Route per l'autenticazione
  static const String splash = '/';
  static const String login = '/login';
  
  // Route principali con bottom navigation
  static const String home = '/home';
  static const String products = '/products';
  static const String orders = '/orders';
  static const String profile = '/profile';
  
  // Route per dettagli (con parametri)
  static const String productDetails = '/products/:id';
  static const String orderDetails = '/orders/:id';
  
  // Route per settings e altre funzionalità
  static const String settings = '/settings';
  static const String search = '/search';
  
  // Route per gestione errori
  static const String notFound = '/404';
  
  /// Genera il path per i dettagli di un prodotto con l'ID specificato
  static String productDetailsPath(String productId) => '/products/$productId';
  
  /// Genera il path per i dettagli di un ordine con l'ID specificato
  static String orderDetailsPath(String orderId) => '/orders/$orderId';
  
  /// Genera il path di ricerca con query parameters
  static String searchPath({String? query, String? category}) {
    final queryParams = <String>[];
    if (query != null && query.isNotEmpty) {
      queryParams.add('q=$query');
    }
    if (category != null && category.isNotEmpty) {
      queryParams.add('category=$category');
    }
    
    return queryParams.isEmpty 
        ? search 
        : '$search?${queryParams.join('&')}';
  }
}
