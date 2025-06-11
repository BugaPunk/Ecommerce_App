import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/category.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/category_service.dart';
import '../../../utils/size_config.dart';

// Importar las categorías de demostración
import '../../../models/category.dart' show demoCategories;

class CategoriesScreen extends StatefulWidget {
  static String routeName = "/categories";

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      // El servicio ahora maneja automáticamente el fallback a datos de demostración
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('[DEBUG_LOG] Error in _loadCategories: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error al cargar las categorías',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenWidth(10)),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: getProportionateScreenWidth(20)),
                        ElevatedButton(
                          onPressed: _loadCategories,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : _categories.isEmpty
                  ? const Center(child: Text('No hay categorías disponibles'))
                  : Padding(
                      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                          crossAxisSpacing: getProportionateScreenWidth(16),
                          mainAxisSpacing: getProportionateScreenWidth(16),
                          childAspectRatio: 1,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return CategoryGridCard(category: _categories[index]);
                        },
                      ),
                    ),
    );
  }
}

class CategoryGridCard extends StatelessWidget {
  final Category category;

  const CategoryGridCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navegar a la lista de productos de esta categoría
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Categoría seleccionada: ${category.nombre}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(category.nombre),
                color: Theme.of(context).colorScheme.primary,
                size: getProportionateScreenWidth(30),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
              child: Text(
                category.nombre,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(5)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
              child: Text(
                category.descripcion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(12),
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electrónicos':
      case 'electrónica':
        return Icons.devices;
      case 'ropa':
      case 'moda':
        return Icons.shopping_bag;
      case 'hogar':
        return Icons.home;
      case 'deportes':
        return Icons.sports;
      case 'juguetes':
        return Icons.toys;
      case 'libros':
        return Icons.book;
      case 'música':
        return Icons.music_note;
      case 'películas':
        return Icons.movie;
      case 'jardín':
        return Icons.landscape;
      case 'mascotas':
        return Icons.pets;
      case 'accesorios':
        return Icons.headset;
      case 'computadoras':
        return Icons.computer;
      default:
        return Icons.category;
    }
  }
}