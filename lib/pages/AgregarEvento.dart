import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_firebase/providers/eventos_providers.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:proyecto_firebase/services/SeleccionarImagen.dart';
import 'package:proyecto_firebase/services/SubirImagen.dart';

class AgregarEvento extends StatefulWidget {
  const AgregarEvento({Key? key});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  File? imagenSubir;
  TextEditingController nombreController = TextEditingController(text: "");
  TextEditingController descripcionController = TextEditingController(text: "");
  TextEditingController lugarController = TextEditingController(text: "");
  TextEditingController tipoController = TextEditingController(text: "");
  DateTime? fechaSeleccionada;
  int likess = 0;

  void mostrarAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Guardando...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.twistingDots(
                leftDotColor: Colors.purple,
                rightDotColor: Colors.yellowAccent,
                size: 50,
              ),
              SizedBox(height: 10),
              Text('Guardando datos en la base de datos.'),
            ],
          ),
        );
      },
    );
  }

  late EventosProvider eventosProvider;
  bool sw = false;

  @override
  void didChangeDependencies() {
    if (!sw) {
      sw = true;
      eventosProvider = Provider.of<EventosProvider>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Agregar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: nombreController,
              label: 'Nombre del evento',
              hintText: 'Ingrese el nombre del evento',
            ),
            _buildTextField(
              controller: descripcionController,
              label: 'Descripción',
              hintText: 'Ingrese la descripción del evento',
              maxLines: 3,
            ),
            _buildDateTimeField(
              label: 'Fecha del evento',
            ),
            _buildTextField(
              controller: lugarController,
              label: 'Lugar',
              hintText: 'Ingrese el lugar del evento',
            ),
            _buildTextField(
              controller: tipoController,
              label: 'Tipo',
              hintText: 'Ingrese el tipo del evento',
            ),
            SizedBox(height: 20),
            _buildImageSelection(),
            SizedBox(height: 20),
            _buildGuardarButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DateTimeField(
        format: DateFormat("yyyy-MM-dd HH:mm"),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        onChanged: (fechaSeleccionada) {
          setState(() {
            this.fechaSeleccionada = fechaSeleccionada;
          });
        },
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2101),
          );
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    );
  }

  Widget _buildImageSelection() {
    return imagenSubir != null
        ? Image.file(
            imagenSubir!,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          )
        : Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final imagen = await getImage();
                  setState(() {
                    imagenSubir = File(imagen!.path);
                  });
                },
                child: Text('Seleccionar imagen'),
              ),
              SizedBox(height: 10),
            ],
          );
  }

  Widget _buildGuardarButton() {
    return ElevatedButton(
      onPressed: () async {
        mostrarAlertDialog();
        Timestamp fechaTimestamp = Timestamp.fromDate(fechaSeleccionada ?? DateTime.now());
        await Future.delayed(Duration(seconds: 3));
        eventosProvider
            .addEventos(
          nombreController.text,
          descripcionController.text,
          lugarController.text,
          tipoController.text,
          likess,
          fechaTimestamp,
        )
            .then((_) {
          Navigator.pushNamed(context, '/');
        });
        if (imagenSubir == null) {
          return;
        }
        final uploaded = await uploadImage(imagenSubir!);
        if (uploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagen subida exitosamente.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al subir la imagen.')),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
      ),
      child: const Text("Guardar"),
    );
  }
}
