import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../models/store.dart';
import '../../widgets/common/loading_widget.dart';

class StoreFormScreen extends StatefulWidget {
  final Store? store;

  const StoreFormScreen({Key? key, this.store}) : super(key: key);

  @override
  State<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends State<StoreFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoTiendaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool get _isEditing => widget.store != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (_isEditing) {
      final store = widget.store!;
      _codigoTiendaController.text = store.codigoTienda ?? '';
      _nombreController.text = store.nombre;
      _descripcionController.text = store.descripcion;
      _direccionController.text = store.direccion ?? '';
      _telefonoController.text = store.telefono ?? '';
      _emailController.text = store.email ?? '';
    }
  }

  @override
  void dispose() {
    _codigoTiendaController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Tienda' : 'Nueva Tienda'),
        backgroundColor: _isEditing ? Colors.orange.shade700 : Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Guardando tienda...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header con icono
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isEditing 
                              ? [Colors.orange.shade700, Colors.orange.shade500]
                              : [Colors.green.shade700, Colors.green.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _isEditing ? Icons.edit_outlined : Icons.add_business,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isEditing ? 'Editar Tienda' : 'Crear Nueva Tienda',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isEditing 
                                ? 'Modifica los datos de la tienda'
                                : 'Completa la información para crear una nueva tienda',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Información básica
                    _buildSectionTitle('Información Básica'),
                    const SizedBox(height: 16),

                    // Código de tienda (solo para crear)
                    if (!_isEditing) ...[
                      TextFormField(
                        controller: _codigoTiendaController,
                        decoration: const InputDecoration(
                          labelText: 'Código de Tienda *',
                          hintText: 'Ej: TIENDA001',
                          prefixIcon: Icon(Icons.qr_code),
                          border: OutlineInputBorder(),
                          helperText: 'Código único identificador de la tienda',
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El código de tienda es obligatorio';
                          }
                          if (value.trim().length < 3) {
                            return 'El código debe tener al menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Nombre
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la Tienda *',
                        hintText: 'Ej: Tienda Electrónica Central',
                        prefixIcon: Icon(Icons.store),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        if (value.trim().length < 2) {
                          return 'El nombre debe tener al menos 2 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Descripción
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción *',
                        hintText: 'Describe qué tipo de productos vende la tienda',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La descripción es obligatoria';
                        }
                        if (value.trim().length < 10) {
                          return 'La descripción debe tener al menos 10 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Información de contacto
                    _buildSectionTitle('Información de Contacto'),
                    const SizedBox(height: 16),

                    // Dirección
                    TextFormField(
                      controller: _direccionController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Ej: Av. Principal 123, Centro',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
                          return 'La dirección debe tener al menos 5 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Teléfono
                    TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        hintText: 'Ej: +1 234-567-8900',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          // Validación básica de teléfono
                          final phoneRegex = RegExp(r'^[\+]?[0-9\-\s\(\)]{7,}$');
                          if (!phoneRegex.hasMatch(value.trim())) {
                            return 'Formato de teléfono inválido';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Ej: contacto@tienda.com',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          // Validación de email
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Formato de email inválido';
                          }
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Botones de acción
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isEditing ? Colors.orange.shade700 : Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _isEditing ? 'Actualizar Tienda' : 'Crear Tienda',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Nota informativa
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Los campos marcados con * son obligatorios',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final storeProvider = Provider.of<StoreProvider>(context, listen: false);
      bool success = false;

      if (_isEditing) {
        // Actualizar tienda existente
        final updateRequest = StoreUpdateRequest(
          nombre: _nombreController.text.trim(),
          descripcion: _descripcionController.text.trim(),
          direccion: _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim(),
          telefono: _telefonoController.text.trim().isEmpty ? null : _telefonoController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        );

        success = await storeProvider.updateStore(widget.store!.id, updateRequest);
      } else {
        // Crear nueva tienda
        final storeRequest = StoreRequest(
          codigoTienda: _codigoTiendaController.text.trim(),
          nombre: _nombreController.text.trim(),
          descripcion: _descripcionController.text.trim(),
          direccion: _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim(),
          telefono: _telefonoController.text.trim().isEmpty ? null : _telefonoController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        );

        success = await storeProvider.createStore(storeRequest);
      }

      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing 
                  ? 'Tienda actualizada exitosamente'
                  : 'Tienda creada exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              storeProvider.error ?? 
              (_isEditing ? 'Error al actualizar tienda' : 'Error al crear tienda'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}