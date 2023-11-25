import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_firebase/providers/eventos_providers.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';

class EditarEvento extends StatefulWidget {
  const EditarEvento({super.key});

  @override
  State<EditarEvento> createState() => _EditarEventoState();
}

class _EditarEventoState extends State<EditarEvento> {
  TextEditingController nombreController = TextEditingController(text: "");
  TextEditingController descripcionController = TextEditingController(text: "");
  TextEditingController lugarController = TextEditingController(text: "");
  TextEditingController tipoController = TextEditingController(text: "");
  TextEditingController fechaController = TextEditingController();
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
                size: 200,
              ),
              SizedBox(height: 10),
              Text('Se están actualizando los datos en la base de datos.'),
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
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    String textFromNombre = arguments['nombre']?.toString() ?? '';
    RegExp regExp = RegExp(r'"([^"]*)"');
    RegExpMatch? match = regExp.firstMatch(textFromNombre);
    String extractedText = match?.group(1) ?? '';

    String textFromDescripcion = arguments['descripcion']?.toString() ?? '';
    RegExp regExp1 = RegExp(r'"([^"]*)"');
    RegExpMatch? match1 = regExp1.firstMatch(textFromDescripcion);
    String extractedText1 = match1?.group(1) ?? '';

    String textFromLugar = arguments['lugar']?.toString() ?? '';
    RegExp regExp2 = RegExp(r'"([^"]*)"');
    RegExpMatch? match2 = regExp2.firstMatch(textFromLugar);
    String extractedText2 = match2?.group(1) ?? '';

    String textFromTipo = arguments['tipo']?.toString() ?? '';
    RegExp regExp3 = RegExp(r'"([^"]*)"');
    RegExpMatch? match3 = regExp3.firstMatch(textFromTipo);
    String extractedText3 = match3?.group(1) ?? '';

    nombreController.text = extractedText;
    descripcionController.text = extractedText1;
    lugarController.text = extractedText2;
    tipoController.text = extractedText3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del evento',
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: descripcionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Descripción del evento',
              ),
            ),
            SizedBox(height: 15),
            DateTimeField(
              controller: fechaController,
              format: DateFormat("yyyy-MM-dd HH:mm"),
              decoration: InputDecoration(
                labelText: 'Fecha del evento',
              ),
              onShowPicker: (context, currentValue) async {
                // ... (resto del código sin cambios)
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: lugarController,
              decoration: InputDecoration(
                labelText: 'Lugar del evento',
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: tipoController,
              decoration: InputDecoration(
                labelText: 'Tipo del evento',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                mostrarAlertDialog();
                Timestamp fechaTimestamp = Timestamp.fromDate(
                  DateFormat("yyyy-MM-dd HH:mm").parse(fechaController.text),
                );
                await Future.delayed(Duration(seconds: 3));
                eventosProvider.editarEventos(
                  arguments['id'],
                  nombreController.text,
                  descripcionController.text,
                  lugarController.text,
                  tipoController.text,
                  fechaTimestamp,
                ).then((_) {
                  Navigator.pushNamed(context, '/');
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
              ),
              child: Text("Actualizar"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                eventosProvider.borrarEventos(arguments['id']).then((_) {
                  Navigator.pushNamed(context, '/');
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text('Borrar evento'),
            ),
          ],
        ),
      ),
    );
  }
}
