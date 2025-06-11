import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../utils/responsive_layout.dart';
import '../../widgets/vendor_drawer.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;

  @override
  void initState() {
    super.initState();
    // Buscar el producto en la lista actual del provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final product = productProvider.products.firstWhere(
        (p) => p.id == widget.productId,
        orElse: () => Product(
          id: 0,
          nombre: '',
          descripcion: '',
          precio: 0.0,
          stock: 0,
          estado: 'ACTIVO',
          fechaRegistro: '',
          categoriaId: 0,
        ),
      );
      
      if (product.id != 0) {
        setState(() {
          _product = product;
        });
        productProvider.selectProduct(product);
      }
    });
  }

  @override
  void dispose() {
    // Limpiar el producto seleccionado al salir
    Provider.of<ProductProvider>(context, listen: false).clearSelectedProduct();
    super.dispose();
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
        title: const Text('Detalles del Producto'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (_product != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar Producto',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductFormScreen(product: _product),
                  ),
                ).then((_) {
                  // Recargar el producto después de editar
                  final productProvider = Provider.of<ProductProvider>(context, listen: false);
                  final updatedProduct = productProvider.products.firstWhere(
                    (p) => p.id == widget.productId,
                    orElse: () => _product!,
                  );
                  setState(() {
                    _product = updatedProduct;
                  });
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Eliminar Producto',
              color: Colors.red,
              onPressed: () {
                _showDeleteDialog(context);
              },
            ),
          ],
        ],
      ),
      drawer: const VendorDrawer(),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    if (_product == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Producto no encontrado',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    final statusColor = _getStatusColor(_product!.estado);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.inventory_2,
              size: 80,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Información principal
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _product!.nombre,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${_product!.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _getStatusText(_product!.estado),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _product!.descripcion,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Información detallada
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información del Producto',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('ID', _product!.id.toString()),
                  _buildInfoRow('Nombre', _product!.nombre),
                  _buildInfoRow('Precio', '\$${_product!.precio.toStringAsFixed(2)}'),
                  _buildInfoRow('Stock', _product!.stock.toString()),
                  _buildInfoRow('Estado', _getStatusText(_product!.estado)),
                  _buildInfoRow('Categoría ID', _product!.categoriaId.toString()),
                  _buildInfoRow('Fecha de Registro', _product!.fechaRegistro),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Información de stock
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado del Inventario',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        _product!.stock > 10 
                            ? Icons.check_circle 
                            : _product!.stock > 0 
                                ? Icons.warning 
                                : Icons.error,
                        color: _product!.stock > 10 
                            ? Colors.green 
                            : _product!.stock > 0 
                                ? Colors.orange 
                                : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getStockStatus(_product!.stock),
                        style: TextStyle(
                          fontSize: 16,
                          color: _product!.stock > 10 
                              ? Colors.green 
                              : _product!.stock > 0 
                                  ? Colors.orange 
                                  : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _product!.stock / 100, // Asumiendo 100 como stock máximo para la barra
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _product!.stock > 10 ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductFormScreen(product: _product),
                      ),
                    ).then((_) {
                      // Recargar el producto después de editar
                      final productProvider = Provider.of<ProductProvider>(context, listen: false);
                      final updatedProduct = productProvider.products.firstWhere(
                        (p) => p.id == widget.productId,
                        orElse: () => _product!,
                      );
                      setState(() {
                        _product = updatedProduct;
                      });
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    if (_product == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Producto no encontrado',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    final statusColor = _getStatusColor(_product!.estado);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              Expanded(
                flex: 1,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    size: 120,
                    color: Colors.grey,
                  ),
                ),
              ),
              
              const SizedBox(width: 32),
              
              // Información del producto
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información principal
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _product!.nombre,
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '\$${_product!.precio.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _getStatusText(_product!.estado),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _product!.descripcion,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        // Información detallada
                        Expanded(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Información del Producto',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildInfoRow('ID', _product!.id.toString()),
                                  _buildInfoRow('Categoría ID', _product!.categoriaId.toString()),
                                  _buildInfoRow('Fecha de Registro', _product!.fechaRegistro),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Estado del inventario
                        Expanded(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Estado del Inventario',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Stock: ${_product!.stock}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(
                                        _product!.stock > 10 
                                            ? Icons.check_circle 
                                            : _product!.stock > 0 
                                                ? Icons.warning 
                                                : Icons.error,
                                        color: _product!.stock > 10 
                                            ? Colors.green 
                                            : _product!.stock > 0 
                                                ? Colors.orange 
                                                : Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _getStockStatus(_product!.stock),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _product!.stock > 10 
                                              ? Colors.green 
                                              : _product!.stock > 0 
                                                  ? Colors.orange 
                                                  : Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  LinearProgressIndicator(
                                    value: _product!.stock / 100,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _product!.stock > 10 ? Colors.green : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Botones de acción
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductFormScreen(product: _product),
                                ),
                              ).then((_) {
                                // Recargar el producto después de editar
                                final productProvider = Provider.of<ProductProvider>(context, listen: false);
                                final updatedProduct = productProvider.products.firstWhere(
                                  (p) => p.id == widget.productId,
                                  orElse: () => _product!,
                                );
                                setState(() {
                                  _product = updatedProduct;
                                });
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Editar Producto'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showDeleteDialog(context);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Eliminar Producto'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
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
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStockStatus(int stock) {
    if (stock <= 0) return 'Agotado';
    if (stock <= 5) return 'Stock crítico';
    if (stock <= 10) return 'Stock bajo';
    return 'Stock disponible';
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content: Text(
            '¿Estás seguro de que deseas eliminar el producto "${_product!.nombre}"?\n\nEsta acción no se puede deshacer.',
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
                
                final productProvider = Provider.of<ProductProvider>(context, listen: false);
                final success = await productProvider.deleteProduct(_product!.id);
                
                if (context.mounted) {
                  if (success) {
                    Navigator.of(context).pop(); // Volver a la lista
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto eliminado correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al eliminar el producto'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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