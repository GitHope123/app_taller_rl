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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final user = provider.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    width: 1,
                  ),
                  color: theme.colorScheme.surface,
                ),
                child: const ClipOval(
                  child: AppLogoSquare(size: 32, isMain: false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hola, ${user?.nombre.split(' ')[0] ?? ''} ${user?.apellidos.split(' ')[0] ?? ''}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tus tareas asignadas',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
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
      body: Column(
        children: [
          // TabBar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: theme.colorScheme.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.pending_actions_outlined),
                  text: 'Por Realizar',
                ),
                Tab(
                  icon: Icon(Icons.task_alt_outlined),
                  text: 'Tareas Hechas',
                ),
              ],
            ),
          ),
          // TabBarView
          Expanded(
            child: provider.isLoading && provider.misAsignaciones.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Por Realizar
                _buildTaskList(
                  context,
                  provider,
                  theme,
                  isPending: true,
                ),
                // Tab 2: Tareas Hechas
                _buildTaskList(
                  context,
                  provider,
                  theme,
                  isPending: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(
      BuildContext context,
      AppProvider provider,
      ThemeData theme, {
        required bool isPending,
      }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getFilteredAsignaciones(provider.misAsignaciones, isPending),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredAsignaciones = snapshot.data ?? [];

        if (filteredAsignaciones.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchMisDatos(),
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isPending
                            ? Icons.assignment_turned_in_outlined
                            : Icons.celebration_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isPending
                            ? 'Todo listo por ahora'
                            : 'Aún no hay tareas completadas',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          isPending
                              ? 'No tienes operaciones pendientes asignadas.'
                              : 'Las tareas completadas aparecerán aquí.',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchMisDatos(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemCount: filteredAsignaciones.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final item = filteredAsignaciones[i]['asignacion'] as Asignacion;
              return FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: i * 100),
                child: AssignmentCard(
                  key: ValueKey(item.id),
                  asignacion: item,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getFilteredAsignaciones(
      List<Asignacion> asignaciones,
      bool isPending,
      ) async {
    final dataService = DataService();
    final List<Map<String, dynamic>> result = [];

    for (final asignacion in asignaciones) {
      try {
        final cantidadTrabajada = await dataService.getCantidadTrabajada(asignacion.id);
        final cantidadAsignada = asignacion.cantidad.toDouble();
        final cantidadRestante = cantidadAsignada - cantidadTrabajada;
        final isCompleted = cantidadRestante <= 0;

        // Filtrar según el tab
        if (isPending && !isCompleted) {
          result.add({
            'asignacion': asignacion,
            'cantidadTrabajada': cantidadTrabajada,
          });
        } else if (!isPending && isCompleted) {
          result.add({
            'asignacion': asignacion,
            'cantidadTrabajada': cantidadTrabajada,
          });
        }
      } catch (e) {
        // Si hay error, incluir en pendientes por defecto
        if (isPending) {
          result.add({
            'asignacion': asignacion,
            'cantidadTrabajada': 0.0,
          });
        }
      }
    }

    return result;
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
              if (result == true && mounted) {
                _loadCantidadTrabajada();
                // También forzamos actualización del provider para que otros widgets se enteren
                if (mounted) {
                  Provider.of<AppProvider>(context, listen: false).fetchMisDatos();
                }
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
                              ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.5)
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
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          pedCode,
                                          style: theme.textTheme.labelLarge?.copyWith(
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                                ),
                                const SizedBox(width: 8),
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
                              style: theme.textTheme.titleMedium?.copyWith(
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                            ? theme.colorScheme.surfaceContainerHighest
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
                        if (result == true && mounted) {
                          _loadCantidadTrabajada();
                          // Actualizar globalmente también
                          if (mounted) {
                            Provider.of<AppProvider>(context, listen: false).fetchMisDatos();
                          }
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