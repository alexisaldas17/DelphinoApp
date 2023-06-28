import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delphino_app/views/user/pages/perfil_pages/perfil_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/usuario.dart';
import '../../../../providers/user.provider.dart';
import '../../../../theme.notifier.dart';

class EditProfilePage extends StatefulWidget {
  final Usuario user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _displayNameController;
  late TextEditingController _emailController;
  bool _isDarkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.user.nombre);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String newDisplayName = _displayNameController.text;

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Actualizar el displayName en Firebase Authentication
        await currentUser.updateDisplayName(newDisplayName);

        // Obtener la referencia al documento del usuario en la colección "usuarios"
        String userId = currentUser.uid;
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('usuarios').doc(userId);

        // Actualizar el documento en Firebase Firestore
        await userRef.update({
          'nombre': newDisplayName,
        });

        // Actualizar el usuario en el estado
        userProvider.user!.nombre = newDisplayName;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Los cambios se guardaron correctamente.'),
          ),
        );
        // Mostrar mensaje de éxito o realizar otras acciones necesarias
        print('Los cambios se guardaron correctamente.');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar los cambios: $error'),
          ),
        );
        // Mostrar mensaje de error o realizar acciones de manejo de errores
        print('Error al guardar los cambios: $error');
      }
    }

    Navigator.pop(context, newDisplayName);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkModeEnabled = !_isDarkModeEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre de usuario:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _displayNameController,
              decoration:
                  InputDecoration(hintText: 'Ingrese su nombre de usuario'),
            ),
            // Resto del código

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Guardar cambios'),
               style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue[500]!),
            ),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: _toggleTheme,
            //   child: Text('Cambiar a tema oscuro'),
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     themeNotifier.toggleTheme();
      //   },
      //   child: Icon(Icons.color_lens),
      // ),
    );
  }
}
