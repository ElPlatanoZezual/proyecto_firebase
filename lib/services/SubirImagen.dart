import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(File image) async{
  final String nombreImagen = image.path.split("/").last;
  Reference ref = storage.ref().child("images").child(nombreImagen);
  final UploadTask uploadTask = ref.putFile(image);
  final TaskSnapshot task = await uploadTask.whenComplete(() => true);
  final String url = await task.ref.getDownloadURL();
  if (task.state == TaskState.success){
    return true;
  }else{
    return false;
  }
}