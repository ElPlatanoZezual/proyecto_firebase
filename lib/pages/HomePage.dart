import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_firebase/pages/DetallesEventoPage.dart';
import 'package:proyecto_firebase/providers/eventos_providers.dart';
import 'package:proyecto_firebase/providers/login_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTileIndex = -1;
  int likesContador = 0;
  late EventosProvider eventosProvider;
  late LoginProvider loginProvider;
  bool sw = false;

  @override
  void didChangeDependencies() {
    if (!sw) {
      sw = true;
      eventosProvider = Provider.of<EventosProvider>(context);
      loginProvider = Provider.of<LoginProvider>(context);
    }
    super.didChangeDependencies();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.purple,
      title: Text(
        'Eventos Potasio',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
    ),
    drawer: Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (loginProvider.isLoggedIn()) {
                      // Cerrar sesión
                      loginProvider.signOut();
                    } else {
                      // Iniciar sesión
                      loginProvider.signInGoogle();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.purple,
                ),
                child: Text(
                  loginProvider.isLoggedIn()
                      ? 'Cerrar sesión'
                      : 'Iniciar sesión',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    body: FutureBuilder(
      future: eventosProvider.getEventos(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTileIndex = index;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesEventoPage(
                        evento: snapshot.data?[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  color: _selectedTileIndex == index
                      ? Colors.grey[200]
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data?[index]['nombre'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data?[index]['descripcion'] ?? '',
                    ),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            likesContador =
                                (snapshot.data?[index]['likes'] ?? 0) + 1;
                            await eventosProvider.sumarLikes(
                                snapshot.data?[index]['id'], likesContador);
                            setState(() {});
                          },
                          child: Icon(
                            MdiIcons.heart,
                            color: Colors.purple,
                            size: 28.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          (snapshot.data?[index]['likes'] ?? 0).toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    trailing: loginProvider.isLoggedIn()
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/editar', arguments: {
                                "nombre": Text(snapshot.data?[index]['nombre'] ?? ''),
                                "descripcion":
                                    Text(snapshot.data?[index]['descripcion'] ?? ''),
                                "lugar": Text(snapshot.data?[index]['lugar'] ?? ''),
                                "tipo": Text(snapshot.data?[index]['tipo'] ?? ''),
                                "likes": snapshot.data?[index]['likes'] ?? 0,
                                "fecha": snapshot.data?[index]['fecha'] ?? '',
                                "id": snapshot.data?[index]['id'] ?? '',
                              });
                            },
                            child: Icon(
                              MdiIcons.fileEdit,
                              color: Colors.purple,
                              size: 28.0,
                            ),
                          )
                        : null,
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    ),
    floatingActionButton: loginProvider.isLoggedIn()
        ? FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/agregar');
            },
            backgroundColor: Colors.purple,
            child: Icon(
              Icons.add,
              size: 32.0,
            ),
          )
        : null,
  );
}
}