import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_firebase/models/evento.dart';

class EventosProvider with ChangeNotifier{
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Evento> listaEventos = [];

  Future<void>addEventos(String nombre, String descripcion, String lugar, String tipo, likes,Timestamp fecha) async {
    DocumentReference docRef = await db.collection("eventos").add({"nombre":nombre,"descripcion":descripcion,"lugar":lugar,"tipo":tipo,"likes":likes,"fecha": fecha});
    String idDoc = docRef.id;
    docRef.update({'id':idDoc});
  }


  Future<void> editarEventos(String idDoc, String nombre, String descripcion, String lugar, String tipo,Timestamp fecha) async {
    await db.collection("eventos").doc(idDoc).set({"nombre":nombre,"descripcion":descripcion,"lugar":lugar,"tipo":tipo,"fecha": fecha});
  }

  Future<void> borrarEventos(String idDoc) async {
    await db.collection("eventos").doc(idDoc).delete();
  }

  Future <void> sumarLikes(String idDoc, int likes) async{
  await db.collection("eventos").doc(idDoc).update({"likes": likes});
  notifyListeners();
  }

  


  Future<List>getEventos() async {
  List eventos = [];
  CollectionReference collectionReferenceEventos = db.collection('eventos');
  QuerySnapshot queryEvents = await collectionReferenceEventos.get();
  queryEvents.docs.forEach((documento) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final evento = {
      "nombre": data['nombre'],
      "descripcion": data['descripcion'],
      "lugar": data['lugar'],
      "tipo": data['tipo'],
      "likes": data['likes'],
      "fecha": data['fecha'],
      "id": documento.id,
    };
    eventos.add(evento);
  });
  await Future.delayed(const Duration(seconds: 3));
  return eventos;
  }

  String formatFecha(DateTime fecha) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(fecha);
  }
}

