import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';


class AuthService {
  final _storage = const FlutterSecureStorage();
  final _supabase = Supabase.instance.client;

  Future<User?> login(String dni, String password) async {
    try {
      // 1. Validar que el DNI tenga exactamente 8 dígitos
      if (dni.length != 8 || !RegExp(r'^\d{8}$').hasMatch(dni)) {
        throw Exception('El DNI debe tener exactamente 8 dígitos');
      }

      // 2. Construir el email con el formato DNI@taller.com
      final email = '$dni@taller.com';

      // 3. Autenticar con Supabase Auth
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Error de autenticación');
      }

      // 4. Obtener los datos del usuario desde la tabla usuario
      final response = await _supabase
          .from('usuario')
          .select()
          .eq('id_usuario', authResponse.user!.id)
          .maybeSingle();

      if (response == null) {
        throw Exception('Usuario no encontrado en la base de datos');
      }

      final data = response as Map<String, dynamic>;

      // 5. Validación de rol: Solo 'empleado'
      final rol = data['rol'] as String?;
      if (rol != 'empleado') {
        // Cerrar sesión si no es empleado
        await _supabase.auth.signOut();
        throw Exception('Acceso permitido solo para empleados');
      }

      // 6. Guardar el user_id en storage
      await _storage.write(key: 'user_id', value: authResponse.user!.id);
      
      return User.fromJson(data);
    } on AuthException catch (e) {
      // Errores específicos de autenticación de Supabase
      if (e.message.contains('Invalid login credentials')) {
        throw Exception('DNI o contraseña incorrectos');
      }
      throw Exception('Error de autenticación: ${e.message}');
    } on PostgrestException catch (e) {
      throw Exception('Error de base de datos: ${e.message}');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', '')); 
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    await _storage.deleteAll();
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'user_id'); 
  }
}
