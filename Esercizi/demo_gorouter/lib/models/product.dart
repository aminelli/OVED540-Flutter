import 'package:equatable/equatable.dart';

/// Modello che rappresenta un prodotto nell'applicazione e-commerce.
/// 
/// Utilizza Equatable per facilitare il confronto tra oggetti
/// e l'utilizzo con Bloc.
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.inStock = true,
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, category, inStock];

  /// Lista di prodotti di esempio per la demo
  static List<Product> getSampleProducts() {
    return [
      const Product(
        id: '1',
        name: 'Flutter Essentials',
        description: 'Libro completo sullo sviluppo Flutter con esempi pratici',
        price: 29.99,
        imageUrl: 'https://via.placeholder.com/300x400/4285F4/FFFFFF?text=Flutter+Book',
        category: 'Libri',
      ),
      const Product(
        id: '2',
        name: 'Tastiera Meccanica RGB',
        description: 'Tastiera gaming professionale con switch meccanici',
        price: 89.99,
        imageUrl: 'https://via.placeholder.com/300x400/34A853/FFFFFF?text=Keyboard',
        category: 'Elettronica',
      ),
      const Product(
        id: '3',
        name: 'Mouse Wireless',
        description: 'Mouse ergonomico wireless con precisione DPI regolabile',
        price: 39.99,
        imageUrl: 'https://via.placeholder.com/300x400/FBBC04/FFFFFF?text=Mouse',
        category: 'Elettronica',
      ),
      const Product(
        id: '4',
        name: 'Cuffie Bluetooth',
        description: 'Cuffie wireless con cancellazione del rumore attiva',
        price: 149.99,
        imageUrl: 'https://via.placeholder.com/300x400/EA4335/FFFFFF?text=Headphones',
        category: 'Audio',
      ),
      const Product(
        id: '5',
        name: 'Webcam HD',
        description: 'Webcam 1080p per streaming e videoconferenze',
        price: 59.99,
        imageUrl: 'https://via.placeholder.com/300x400/9C27B0/FFFFFF?text=Webcam',
        category: 'Elettronica',
        inStock: false,
      ),
      const Product(
        id: '6',
        name: 'Supporto per Laptop',
        description: 'Supporto ergonomico regolabile in alluminio',
        price: 34.99,
        imageUrl: 'https://via.placeholder.com/300x400/FF6F00/FFFFFF?text=Stand',
        category: 'Accessori',
      ),
    ];
  }

  /// Trova un prodotto per ID
  static Product? findById(String id) {
    try {
      return getSampleProducts().firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

}
