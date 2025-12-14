import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../models/asignacion_model.dart';
import '../providers/app_provider.dart';
import '../theme/theme.dart';

class WorkRegisterScreen extends StatefulWidget {
  final Asignacion asignacion;

  const WorkRegisterScreen({super.key, required this.asignacion});

  @override
  State<WorkRegisterScreen> createState() => _WorkRegisterScreenState();
}

class _WorkRegisterScreenState extends State<WorkRegisterScreen> {
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _cantidadTrabajada = 0.0;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final trab = await provider.getCantidadTrabajada(widget.asignacion.id);
    if (mounted) {
      setState(() {
        _cantidadTrabajada = trab;
        _isLoadingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);
    
    final opName = widget.asignacion.operacion?.nombre ?? 'Operación';
    final pedCode = widget.asignacion.pedido?.codigo ?? '---';
    final pedDesc = widget.asignacion.pedido?.descripcion ?? '';
    
    final cantidadAsignada = widget.asignacion.cantidad;
    final cantidadRestante = (cantidadAsignada - _cantidadTrabajada).clamp(0, double.infinity);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registrar Avance'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'PEDIDO $pedCode',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        opName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (pedDesc.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            pedDesc,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      const SizedBox(height: 32),
                      
                      _isLoadingData 
                        ? const CircularProgressIndicator()
                        : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatItem(
                            label: 'ASIGNADO',
                            value: '${cantidadAsignada.toInt()}', // Assuming int for Assigned usually
                            color: theme.colorScheme.secondary,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            color: theme.dividerColor,
                          ),
                          _StatItem(
                            label: 'RESTANTE',
                            value: '${cantidadRestante.toInt()}', 
                            color: cantidadRestante == 0 ? Colors.green : theme.colorScheme.primary,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingrese Cantidad',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '0',
                          suffixText: 'unidades',
                          filled: true,
                          fillColor: theme.cardTheme.color,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un valor';
                          }
                          final v = double.tryParse(value);
                          if (v == null || v <= 0) {
                            return 'Cantidad inválida';
                          }
                          if (v > cantidadRestante) {
                            return 'Excede lo restante ($cantidadRestante)';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              if (provider.errorMessage != null)
                FadeIn(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: errorColor),
                        const SizedBox(width: 12),
                        Expanded(child: Text(provider.errorMessage!, style: TextStyle(color: errorColor))),
                      ],
                    ),
                  ),
                ),

              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 800),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                      shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                    ),
                    onPressed: provider.isLoading || cantidadRestante <= 0
                      ? null 
                      : () async {
                          if (_formKey.currentState!.validate()) {
                              final cant = double.parse(_quantityController.text);
                              final success = await provider.registrarAvance(widget.asignacion.id, cant);
                              
                              if (success && context.mounted) {
                                await _loadProgress(); // Reload progress after success
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('¡Excelente! Avance registrado.'),
                                    backgroundColor: theme.colorScheme.secondary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                                Navigator.pop(context, true);
                              }
                          }
                      },
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('CONFIRMAR REGISTRO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600, 
            letterSpacing: 1, 
            color: Colors.grey.shade600
          )
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }
}
