import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bcrypt/bcrypt.dart';
import '../models/user_model.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final _supabase = Supabase.instance.client;

  Future<User?> login(String dni, String password) async {
    try {
      // 1. Buscamos el usuario SOLO por DNI (sin comprobar password aun en DB)
      final response = await _supabase
          .from('usuario')
          .select()
          .eq('dni', dni)
          .maybeSingle();

      if (response == null) {
        throw Exception('Usuario no encontrado');
      }

      final data = response as Map<String, dynamic>;
      
      // 2. Verificamos la contraseña hasheada (bcrypt)
      final String storedHash = data['password'] ?? '';
      
      // Si la contraseña en DB no es un hash válido (ej. texto plano antiguo),
      // BCrypt lanzará error o fallará. Manejamos ambos casos.
      bool isPasswordCorrect = false;
      try {
        isPasswordCorrect = BCrypt.checkpw(password, storedHash);
      } catch (_) {
         // Fallback: Si no es hash valido, probamos igualdad simple (por si acaso hay legacy plain text)
         if (storedHash == password) {
           isPasswordCorrect = true;
         }
      }

      if (!isPasswordCorrect) {
        throw Exception('Contraseña incorrecta');
      }

      // 3. Validación estricta de rol: Solo 'empleado'
      final rol = data['rol'] as String?;
      if (rol != 'empleado') {
        throw Exception('Acceso permitido solo para empleados. Tu rol es: $rol');
      }

      // Login exitoso
      await _storage.write(key: 'user_id', value: data['id_usuario']);
      
      return User.fromJson(data);
    } catch (e) {
      if (e is PostgrestException) {
         throw Exception('Error de base de datos: ${e.message}');
      }
      throw Exception(e.toString().replaceAll('Exception: ', '')); 
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'user_id'); 
  }
}
