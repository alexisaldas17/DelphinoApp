import 'package:delphino_app/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../providers/user.provider.dart';
import '../../../welcome_screen.dart';
import 'editar_perfil_page.dart';

class PerfilPage extends StatefulWidget {
  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final AuthController _auth = AuthController();
  late UserProvider userProvider;
  late Usuario? _user; // Usuario actualmente autenticado

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    // Obtener el usuario actualmente autenticado al iniciar la pantalla
    _user = userProvider.user;
  }

  // Método para Cerrar Sesión
 void _handleSignOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
            ),
            TextButton(
              child: Text('Cerrar sesión'),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  // Redireccionar a la página de inicio de sesión
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                } catch (e) {
                  // Manejo de errores
                  print('Error al cerrar sesión: $e');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Se produjo un error al cerrar sesión.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context); // Cerrar el diálogo
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _handleEditProfile(BuildContext context) async {
    final editedUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(user: _user!)),
    );

    if (editedUser != null) {
      setState(() {
        _user!.nombre = editedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 45.0), // Espacio en la parte superior
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(
                    _user!.photoUrl ??
                        'https://firebasestorage.googleapis.com/v0/b/delphinoapp.appspot.com/o/perfil.png?alt=media&token=296aedc6-c28f-4033-8833-f46b53f25bc0',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '¡Bienvenido a tu perfil!',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Nombre de usuario'),
                  subtitle: Text(_user!.nombre ?? 'N/A'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Correo electrónico'),
                  subtitle: Text(_user!.email ?? 'N/A'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.code),
                  title: Text('UID'),
                  subtitle: Text(_user!.uid),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _handleEditProfile(
                    context), // Agrega el manejo del botón de editar perfil
                child: Text('EDITAR PERFIL'),
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue[500]!),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _handleSignOut(context),
                child: Text('CERRAR SESIÓN'),
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[500]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
