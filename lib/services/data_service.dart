import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/asignacion_model.dart';

class DataService {
  final _supabase = Supabase.instance.client;

  // Lógica CORE: Obtener operaciones asignadas al empleado logueado
  Future<List<Asignacion>> getMyOperations(String userId) async {
    try {
      // Hacemos un join triple: Asignacion -> Operacion -> Pedido
      // Nota: Asegúrate de que las Foreign Keys estén bien definidas en Supabase para que este select funcione.
      final response = await _supabase
          .from('asignacion')
          .select('*, operaciones_pedido(*), pedido(*)') 
          .eq('id_usuario', userId) 
          .order('fecha_asignacion', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Asignacion.fromSupabase(json)).toList();
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }
  
  // Registrar avance
  Future<void> registrarAvance(String idAsignacion, double cantidad, double? pagoCalculado) async {
    try {
        await _supabase.from('registro_trabajo').insert({
          'id_registro': const Uuid().v4(), // Generar UUID cliente al no ser serial
          'id_asignacion': idAsignacion,
          'cantidad_trabajada': cantidad,
          'pago': pagoCalculado ?? 0, // Backend trigger podria actualizar esto
          'fecha_registro': DateTime.now().toIso8601String(),
        });
    } catch (e) {
      print('Error registrando avance: $e');
      throw e;
    }
  }

  // Obtener cantidad ya trabajada para una asignación
  Future<double> getCantidadTrabajada(String idAsignacion) async {
    try {
      final response = await _supabase
          .from('registro_trabajo')
          .select('cantidad_trabajada')
          .eq('id_asignacion', idAsignacion);

      if (response == null) return 0.0;
      
      final List<dynamic> data = response as List<dynamic>;
      double total = 0.0;
      for (var item in data) {
         total += (item['cantidad_trabajada'] as num).toDouble();
      }
      return total;
    } catch (e) {
      print('Error fetching worked quantity: $e');
      return 0.0;
    }
  }
}
