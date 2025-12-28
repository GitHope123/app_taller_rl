import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../models/user_model.dart';
import '../models/asignacion_model.dart';

class AppProvider with ChangeNotifier {
  User? _currentUser;
  List<Asignacion> _misAsignaciones = [];
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  List<Asignacion> get misAsignaciones => _misAsignaciones;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final _authService = AuthService();
  final _dataService = DataService();

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String dni, String password) async {
    setLoading(true);
    _errorMessage = null;
    try {
      _currentUser = await _authService.login(dni, password);
      // Una vez logueado, cargamos sus datos automáticamente
      if (_currentUser != null) {
        await fetchMisDatos();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> tryAutoLogin() async {
    // Basic auto-login: check if token exists. 
    // Ideally we should validate token with backend or load user profile.
    final token = await _authService.getToken();
    if (token != null) {
       // Since we don't have a 'getUserProfile' endpoint in AuthService (just login), 
       // we might need to rely on stored user ID or just let them stay logged in 
       // if we trust the token. 
       // The original README didn't have a 'getUser' endpoint, only login.
       // However, we stored 'user_id'. 
       // For a robust app, we should fetch the user. 
       // Here, we will just return false to force login for safety 
       // UNLESS we can fetch user data.
       // But wait, DataService uses user ID.
       // Let's see if we can read user_id from storage.
       // To do this properly, AuthService needs to expose reading user_id too.
       return false; 
    }
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _misAsignaciones = [];
    notifyListeners();
  }

  Future<void> fetchMisDatos() async {
    if (_currentUser == null) return;
    try {
      _misAsignaciones = await _dataService.getMyOperations(_currentUser!.id);
      notifyListeners();
    } catch (e) {
      print('Error cargando datos: $e');
      // Podríamos setear un error message aquí si queremos mostrarlo en UI
    }
  }

  Future<bool> registrarAvance(String idAsignacion, double cantidad) async {
    setLoading(true);
    try {
      // Calculate payment: quantity * minutes_per_unit
      double pagoCalculado = 0.0;
      try {
        final asignacion = _misAsignaciones.firstWhere((a) => a.id == idAsignacion);
        final minutos = asignacion.operacion?.minutosUnidad ?? 0;
        pagoCalculado = cantidad * minutos;
      } catch (e) {
         print('Warning: Could not calculate payment locally: $e');
      }

      await _dataService.registrarAvance(idAsignacion, cantidad, pagoCalculado);
      
      // Recargar datos para actualizar estado si fuera necesario (ej. progreso)
      await fetchMisDatos();
      return true;
    } catch (e) {
       _errorMessage = 'Error registrando avance: ${e.toString()}';
       return false;
    } finally {
      setLoading(false);
    }
  }
  
  Future<double> getCantidadTrabajada(String idAsignacion) async {
    return await _dataService.getCantidadTrabajada(idAsignacion);
  }

  Future<double?> getPreconditionLimit(String orderId, String operationName) async {
    return await _dataService.getPreconditionLimit(orderId, operationName);
  }
}
