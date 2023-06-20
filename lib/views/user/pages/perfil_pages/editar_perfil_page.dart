import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme.notifier.dart';


class EditProfilePage extends StatefulWidget {
  final User user;

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
    _displayNameController =
        TextEditingController(text: widget.user.displayName);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Aquí puedes obtener los valores editados de los campos de texto y guardar los cambios en tu sistema
    String newDisplayName = _displayNameController.text;
    String newEmail = _emailController.text;

    // Ejemplo de cómo actualizar los atributos del usuario en Firebase Authentication
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUser.updateDisplayName(newDisplayName);
      currentUser.updateEmail(newEmail);
    }

    // También puedes guardar los cambios en tu propio sistema de base de datos, si lo tienes

    // Después de guardar los cambios, puedes cerrar la pantalla y regresar al perfil
    Navigator.pop(context);
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
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _toggleTheme,
              child: Text('Cambiar a tema oscuro'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          themeNotifier.toggleTheme();
        },
        child: Icon(Icons.color_lens),
      ),
    );
  }
}
