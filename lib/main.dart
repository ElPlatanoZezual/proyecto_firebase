import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//Importacion de paginas
import 'package:proyecto_firebase/pages/AgregarEvento.dart';
import 'package:proyecto_firebase/pages/DetallesEventoPage.dart';
import 'package:proyecto_firebase/pages/EditarEvento.dart';
import 'package:proyecto_firebase/pages/HomePage.dart';
//importacion de firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_firebase/providers/eventos_providers.dart';
import 'package:proyecto_firebase/providers/login_provider.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform 
    );
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>EventosProvider()),
        ChangeNotifierProvider(create: (_)=>LoginProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/':(context) => const HomePage(),
          '/detalles': (context)=> const DetallesEventoPage(),
          '/agregar': (context) => const AgregarEvento(),
          '/editar':(context) => const EditarEvento(),      },
      ),
    );
  }
}

