
import 'package:cloud_firestore/cloud_firestore.dart';

class Evento{
  final String id;
  final String nombre;
  final String descripcion;
  final String lugar;
  final int likes;
  final Timestamp fecha;
  final String tipo;

  Evento({required this.id, required this.nombre, required this.descripcion, required this.lugar, required this.likes, required this.fecha, required this.tipo});
}