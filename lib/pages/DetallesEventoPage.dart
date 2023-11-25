import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_firebase/services/getImage.dart';

// Añade esta importación

class DetallesEventoPage extends StatefulWidget {
  final Map<String, dynamic>? evento;

  const DetallesEventoPage({Key? key, this.evento}) : super(key: key);

  @override
  State<DetallesEventoPage> createState() => _DetallesEventoPageState();
}

class _DetallesEventoPageState extends State<DetallesEventoPage> {
  String imageUrl = ''; // Variable para almacenar la URL de la imagen

  @override
  void initState() {
    super.initState();
    // Obtén la URL de la imagen cuando se inicia la página
    getImageUrlForEvent();
  }

  // Método para obtener la URL de la imagen usando el servicio
  void getImageUrlForEvent() async {
    if (widget.evento != null && widget.evento!['imagen_path'] != null) {
      String imagePath = widget.evento!['imagen_path'];
      String url = await getImageUrl(imagePath);
      setState(() {
        imageUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Timestamp? fechaHora = widget.evento?['fecha_hora'];
    DateTime fechaHoraDateTime = fechaHora != null ? fechaHora.toDate() : DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(fechaHoraDateTime);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Detalles del Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar la foto
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                width: 200, // Ajusta el tamaño según tus necesidades
                height: 200,
                fit: BoxFit.cover,
              ),
            _buildDetailRow('Nombre', '${widget.evento?['nombre']}'),
            _buildDetailRow('Descripción', '${widget.evento?['descripcion']}'),
            _buildDetailRow('Lugar', '${widget.evento?['lugar']}'),
            _buildDetailRow('Tipo', '${widget.evento?['tipo']}'),
            _buildDetailRow('Fecha y hora', formattedDate),
            _buildDetailRow('Cantidad de likes', '${widget.evento?['likes']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 18)),
        Divider(),
      ],
    );
  }
}
