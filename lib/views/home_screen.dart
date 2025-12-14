import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/app_provider.dart';
import '../models/asignacion_model.dart';
import '../services/data_service.dart';
import '../widgets/app_logo.dart';
import 'work_register_screen.dart';
import 'login_screen.dart';
import '../theme/theme.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final user = provider.currentUser;
    final theme = Theme.of(context);

    // Refresh automatically if empty & no error
    if (provider.misAsignaciones.isEmpty && !provider.isLoading && provider.errorMessage == null) {
      // Avoid loop, check logic in provider usually
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2), // Space for border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    width: 1,
                  ),
                  color: theme.colorScheme.surface, // Background to ensure transparency doesn't look weird
                ),
                child: ClipOval(
                  child: const AppLogoSquare(size: 36, isMain: false),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, ${user?.nombre.split(' ')[0] ?? ''} ${user?.apellidos.split(' ')[0] ?? ''}', 
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 4),
                  Text('Tus tareas asignadas', style: theme.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                IconButton.filledTonal(
                  onPressed: () => provider.fetchMisDatos(), 
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () {
                    provider.logout();
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (r) => false
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: errorColor),
                  style: IconButton.styleFrom(backgroundColor: errorColor.withOpacity(0.1)),
                )
              ],
            ),
          )
        ],
      ),
      body: provider.isLoading && provider.misAsignaciones.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchMisDatos(),
              child: provider.misAsignaciones.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in_outlined, size: 80, color: theme.colorScheme.onSurface.withOpacity(0.2)),
                          const SizedBox(height: 24),
                          Text(
                            'Todo listo por ahora',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No tienes operaciones pendientes asignadas.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      itemCount: provider.misAsignaciones.length,
                      separatorBuilder: (_,__) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final item = provider.misAsignaciones[i];
                        return FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: Duration(milliseconds: i * 100),
                          child: AssignmentCard(
                            key: ValueKey(item.id),
                            asignacion: item
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

class AssignmentCard extends StatefulWidget {
  final Asignacion asignacion;

  const AssignmentCard({super.key, required this.asignacion});

  @override
  State<AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  double cantidadTrabajada = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCantidadTrabajada();
  }

  @override
  void didUpdateWidget(AssignmentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asignacion.id != widget.asignacion.id) {
      _loadCantidadTrabajada();
    }
  }

  Future<void> _loadCantidadTrabajada() async {
    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      final trabajada = await provider.getCantidadTrabajada(widget.asignacion.id);
      if (mounted) {
        setState(() {
          cantidadTrabajada = trabajada;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opName = widget.asignacion.operacion?.nombre ?? 'Operación Desconocida';
    final pedCode = widget.asignacion.pedido?.codigo ?? '---';
    final secuencia = widget.asignacion.pedido?.secuencia ?? 0;
    final cantidadAsignada = widget.asignacion.cantidad.toDouble();
    final cantidadRestante = cantidadAsignada - cantidadTrabajada;
    final isCompleted = cantidadRestante <= 0;
    
    String dateStr = widget.asignacion.fecha;
    try {
      final date = DateTime.parse(widget.asignacion.fecha);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);
      final difference = today.difference(dateOnly).inDays;
      
      final timeStr = DateFormat('h:mm a').format(date);
      
      if (dateOnly == today) {
        dateStr = 'Hoy, $timeStr';
      } else if (dateOnly == yesterday) {
        dateStr = 'Ayer, $timeStr';
      } else if (difference > 0 && difference <= 7) {
        dateStr = 'Hace $difference día${difference > 1 ? 's' : ''}';
      } else {
        // Formato: "10 dic"
        final months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 
                       'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
        dateStr = '${date.day} ${months[date.month - 1]}';
      }
    } catch (_) {}

    return Opacity(
      opacity: isCompleted ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted 
              ? theme.cardTheme.color?.withOpacity(0.6) 
              : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isCompleted 
                ? theme.colorScheme.outline.withOpacity(0.3)
                : theme.colorScheme.outline.withOpacity(0.5)
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: isCompleted ? null : () async {
              final result = await Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => WorkRegisterScreen(asignacion: widget.asignacion)),
               );
               if (result == true) {
                 _loadCantidadTrabajada();
                 // También forzamos actualización del provider para que otros widgets se enteren
                 Provider.of<AppProvider>(context, listen: false).fetchMisDatos();
               }
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCompleted 
                              ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
                              : theme.colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isCompleted ? Icons.check_circle_outline : Icons.handyman_outlined, 
                          color: isCompleted 
                              ? theme.colorScheme.onSurfaceVariant 
                              : theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Row(
                                   children: [
                                     Text(
                                      pedCode,
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: theme.colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Sec. $secuencia',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSecondaryContainer,
                                        ),
                                      ),
                                    ),
                                   ],
                                 ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    dateStr, 
                                    style: TextStyle(
                                      fontSize: 11, 
                                      color: theme.colorScheme.onSurface.withOpacity(0.6)
                                    )
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              opName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoBadge(
                          context, 
                          'Asignado', 
                          '${cantidadAsignada.toStringAsFixed(0)}', 
                          Icons.assignment_outlined,
                          theme.colorScheme.primary,
                        ),
                        _buildInfoBadge(
                          context, 
                          'Trabajado', 
                          '${cantidadTrabajada.toStringAsFixed(0)}', 
                          Icons.done_all_outlined,
                          theme.colorScheme.tertiary,
                        ),
                        _buildInfoBadge(
                          context, 
                          'Falta', 
                          '${cantidadRestante > 0 ? cantidadRestante.toStringAsFixed(0) : '0'}', 
                          Icons.pending_outlined,
                          isCompleted ? theme.colorScheme.outline : theme.colorScheme.error,
                        ),
                      ],
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        backgroundColor: isCompleted 
                            ? theme.colorScheme.surfaceVariant 
                            : theme.colorScheme.primary,
                        foregroundColor: isCompleted 
                            ? theme.colorScheme.onSurfaceVariant 
                            : theme.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isCompleted ? null : () async {
                         final result = await Navigator.push(
                           context,
                           MaterialPageRoute(builder: (_) => WorkRegisterScreen(asignacion: widget.asignacion)),
                         );
                         if (result == true) {
                           _loadCantidadTrabajada();
                           // Actualizar globalmente también
                           Provider.of<AppProvider>(context, listen: false).fetchMisDatos();
                         }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle : Icons.edit_outlined, 
                            size: 18
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCompleted ? 'Completado' : 'Registrar Trabajo',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge(BuildContext context, String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(), 
          style: TextStyle(
            fontSize: 9, 
            letterSpacing: 0.5, 
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          )
        ),
        const SizedBox(height: 2),
        Text(
          value, 
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          )
        ),
      ],
    );
  }
}
