import 'package:firebase_storage/firebase_storage.dart';

Future<String> getImageUrl(String imagePath) async {
  try {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    return await ref.getDownloadURL();
  } catch (e) {
    print('Error al obtener la URL de la imagen: $e');
    return '';
  }
}
