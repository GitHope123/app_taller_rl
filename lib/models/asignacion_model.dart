class Asignacion {
  final String id;
  final String idOperacion;
  final String idPedido; 
  final num cantidad; // numeric in DB
  final String fecha;
  final OperacionPedido? operacion;
  final Pedido? pedido;

  Asignacion({
    required this.id, 
    required this.idOperacion,
    required this.idPedido,
    required this.cantidad, 
    required this.fecha,
    this.operacion,
    this.pedido
  });

  factory Asignacion.fromSupabase(Map<String, dynamic> json) {
    return Asignacion(
      id: json['id_asignacion'].toString(),
      idOperacion: json['id_operacion_pedido'].toString(),
      idPedido: json['id_pedido'].toString(),
      cantidad: json['cantidad_asignada'] ?? 0,
      fecha: json['fecha_asignacion'] ?? '',
      operacion: json['operaciones_pedido'] != null ? OperacionPedido.fromJson(json['operaciones_pedido']) : null,
      pedido: json['pedido'] != null ? Pedido.fromJson(json['pedido']) : null,
    );
  }
}

class OperacionPedido {
  final String id;
  final String nombre;
  final num minutosUnidad;

  OperacionPedido({required this.id, required this.nombre, required this.minutosUnidad});

  factory OperacionPedido.fromJson(Map<String, dynamic> json) {
    return OperacionPedido(
      id: json['id_operacion_pedido'].toString(),
      nombre: json['nombre_operacion'] ?? 'Desconocida',
      minutosUnidad: json['minutos_unidad'] ?? 0,
    );
  }
}

class Pedido {
  final String id;
  final String codigo;
  final String descripcion;
  final int secuencia;

  Pedido({required this.id, required this.codigo, required this.descripcion, required this.secuencia});

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id_pedido'].toString(),
      codigo: json['codigo'] ?? '---',
      descripcion: json['descripcion'] ?? '',
      secuencia: json['secuencia'] ?? 0,
    );
  }
}
