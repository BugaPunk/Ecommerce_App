import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../utils/responsive_layout.dart';
import '../../widgets/vendor_drawer.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();
  // Término de búsqueda
  String _searchTerm = '';
  // Filtro de estado seleccionado
  String _selectedStatusFilter = 'TODOS';

  @override
  void initState() {
    super.initState();
    // Cargar la lista de productos al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.getAllProductsNoPagination();
      productProvider.getAllCategories();
    });
    
    // Añadir listener al controlador de búsqueda
    _searchController.addListener(_filterProducts);
  }
  
  @override
  void dispose() {
    // Limpiar el controlador al destruir el widget
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }
  
  // Método para filtrar productos según el término de búsqueda y estado
  void _filterProducts() {
    setState(() {
      _searchTerm = _searchController.text.toLowerCase().trim();
    });
  }
  
  // Método para obtener los productos filtrados
  List<Product> _getFilteredProducts(List<Product> products) {
    List<Product> filteredProducts = products;
    
    // Filtrar por estado
    if (_selectedStatusFilter != 'TODOS') {
      filteredProducts = filteredProducts.where((product) {
        return product.estado == _selectedStatusFilter;
      }).toList();
    }
    
    // Filtrar por término de búsqueda
    if (_searchTerm.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.nombre.toLowerCase().contains(_searchTerm) ||
               product.descripcion.toLowerCase().contains(_searchTerm) ||
               product.id.toString().contains(_searchTerm);
      }).toList();
    }
    
    return filteredProducts;
  }

  // Obtener color según el estado del producto
  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVO':
        return Colors.green;
      case 'INACTIVO':
        return Colors.orange;
      case 'AGOTADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Obtener texto del estado en español
  String _getStatusText(String status) {
    switch (status) {
      case 'ACTIVO':
        return 'Activo';
      case 'INACTIVO':
        return 'Inactivo';
      case 'AGOTADO':
        return 'Agotado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false).getAllProductsNoPagination();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      drawer: const VendorDrawer(),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProductFormScreen(),
            ),
          ).then((_) {
            // Recargar la lista de productos al volver
            Provider.of<ProductProvider>(context, listen: false).getAllProductsNoPagination();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Error: ${productProvider.errorMessage}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    productProvider.getAllProductsNoPagination();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (productProvider.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay productos registrados',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductFormScreen(),
                      ),
                    ).then((_) {
                      productProvider.getAllProductsNoPagination();
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Producto'),
                ),
              ],
            ),
          );
        }

        // Obtener productos filtrados
        final filteredProducts = _getFilteredProducts(productProvider.products);

        // Mostrar mensaje cuando no hay resultados de búsqueda
        if (filteredProducts.isEmpty && (_searchTerm.isNotEmpty || _selectedStatusFilter != 'TODOS')) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron productos con los filtros aplicados',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _selectedStatusFilter = 'TODOS';
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpiar filtros'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Filtros para móvil
            _buildMobileFilters(),
            
            // Lista de productos
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await productProvider.getAllProductsNoPagination();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(context, product, productProvider);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Error: ${productProvider.errorMessage}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    productProvider.getAllProductsNoPagination();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (productProvider.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay productos registrados',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductFormScreen(),
                      ),
                    ).then((_) {
                      productProvider.getAllProductsNoPagination();
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Producto'),
                ),
              ],
            ),
          );
        }

        // Obtener productos filtrados
        final filteredProducts = _getFilteredProducts(productProvider.products);

        return Column(
          children: [
            // Filtros para escritorio
            _buildDesktopFilters(),
            
            // Tabla de productos para escritorio
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await productProvider.getAllProductsNoPagination();
                },
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron productos con los filtros aplicados',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedStatusFilter = 'TODOS';
                                });
                              },
                              icon: const Icon(Icons.clear),
                              label: const Text('Limpiar filtros'),
                            ),
                          ],
                        ),
                      )
                    : _buildProductsTable(context, filteredProducts, productProvider),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMobileFilters() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Campo de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, descripción...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchTerm.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filtro de estado
          Row(
            children: [
              const Text('Filtrar por estado: '),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedStatusFilter,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ['TODOS', 'ACTIVO', 'INACTIVO', 'AGOTADO']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status == 'TODOS' ? 'Todos' : _getStatusText(status)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFilters() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          // Campo de búsqueda
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, descripción, ID...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchTerm.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Filtro de estado
          const Text('Filtrar por estado: '),
          const SizedBox(width: 8),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              value: _selectedStatusFilter,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: ['TODOS', 'ACTIVO', 'INACTIVO', 'AGOTADO']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status == 'TODOS' ? 'Todos' : _getStatusText(status)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatusFilter = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, ProductProvider productProvider) {
    final statusColor = _getStatusColor(product.estado);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(productId: product.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.nombre,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.descripcion,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${product.precio.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(product.estado),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stock: ${product.stock}',
                    style: TextStyle(
                      fontSize: 14,
                      color: product.stock <= 10 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'Ver detalles',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Editar',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductFormScreen(product: product),
                            ),
                          ).then((_) {
                            productProvider.getAllProductsNoPagination();
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Eliminar',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        color: Colors.red,
                        onPressed: () {
                          _showDeleteDialog(context, product, productProvider);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsTable(BuildContext context, List<Product> products, ProductProvider productProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 56,
          dataRowHeight: 72,
          columns: const [
            DataColumn(
              label: Text(
                'Producto',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Precio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Stock',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Estado',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Acciones',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: products.map((product) {
            final statusColor = _getStatusColor(product.estado);

            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.inventory_2,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.nombre,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              product.descripcion,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    '\$${product.precio.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    product.stock.toString(),
                    style: TextStyle(
                      color: product.stock <= 10 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(product.estado),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'Ver detalles',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Editar',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductFormScreen(product: product),
                            ),
                          ).then((_) {
                            productProvider.getAllProductsNoPagination();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Eliminar',
                        color: Colors.red,
                        onPressed: () {
                          _showDeleteDialog(context, product, productProvider);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Product product, ProductProvider productProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content: Text(
            '¿Estás seguro de que deseas eliminar el producto "${product.nombre}"?\n\nEsta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                final success = await productProvider.deleteProduct(product.id);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Producto eliminado correctamente'
                            : 'Error al eliminar el producto',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}