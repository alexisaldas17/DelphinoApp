import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delphino_app/models/preguntas.dart';
import 'package:delphino_app/models/subniveles.dart';
import '../models/lecciones.dart';
import '../models/niveles.dart';

class AprenderController {
  //AprenderProvider _aprenderProvider;
  //AprenderController(this._aprenderProvider);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _nivelesStreamController = StreamController<List<Nivel>>();
  Stream<List<Nivel>> get nivelesStream => _nivelesStreamController.stream;

  final CollectionReference nivelesCollection =
      FirebaseFirestore.instance.collection('subniveles');

  Future<List<CollectionReference>> getAllCollections(
      String collectionName) async {
    QuerySnapshot snapshot = await firestore.collection(collectionName).get();
    List<CollectionReference> collections = [];

    for (DocumentSnapshot doc in snapshot.docs) {
      CollectionReference collection = doc.reference.collection(collectionName);
      collections.add(collection);
    }

    return collections;
  }

  Future<List<Nivel>> getNiveles() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? cachedData = prefs.getString('cached_data');
    // if (cachedData != null) {
    //   // Si los datos están almacenados en la caché, utilizarlos en lugar de hacer una llamada a Firebase
    //   List<Nivel> cachedNiveles = parseCachedData(cachedData);
    //   _nivelesStreamController.add(cachedNiveles);

    //   //return cachedNiveles;
    // }
    // Obtener los datos de Firebase
    List<Nivel> niveles = await fetchNivelesFromFirebase();
    // AprenderProvider aprenderProvider =
    //       Provider.of<AprenderProvider>(context, listen: false);
    // aprenderProvider.setNivel(niveles);

    return niveles;
    // Comparar los datos obtenidos de Firebase con los datos almacenados en la caché
    // if (!areEqual(cachedData, niveles)) {
    //   // Los datos de Firebase son diferentes a los de la caché, actualizar la caché y emitir los datos actualizados
    //   String dataToCache = serializeNiveles(niveles);
    //   prefs.setString('cached_data', dataToCache);
    //   _nivelesStreamController.add(niveles);
    // }
    // Obtener los datos de Firebase
    // List<Nivel> niveles = await fetchNivelesFromFirebase();

    // // Almacenar los datos en la caché
    // String dataToCache = serializeNiveles(niveles);
    // prefs.setString('cached_data', dataToCache);
    //_nivelesStreamController.add(niveles);

    // // Escuchar los cambios en la colección de niveles y actualizar la caché en caso de cambios
    // nivelesCollection.snapshots().listen((snapshot) async {
    //   niveles =
    //       await fetchNivelesFromFirebase(); // Obtener los datos actualizados de Firebase
    //   dataToCache =
    //       serializeNiveles(niveles); // Serializar los datos actualizados
    //   prefs.setString('cached_data', dataToCache); // Actualizar la caché
    //   _nivelesStreamController
    //       .add(niveles); // Emitir los datos actualizados al stream
    // });
  }

  bool areEqual(String? cachedData, List<Nivel> niveles) {
    // Verificar si los datos almacenados en la caché son iguales a los datos de Firebase
    if (cachedData == null) {
      return false;
    }

    String newData = serializeNiveles(niveles);
    return cachedData == newData;
  }

  Future<List<Nivel>> fetchNivelesFromFirebase() async {
    try {
      CollectionReference nivelesCollection =
          FirebaseFirestore.instance.collection('niveles');

      QuerySnapshot nivelesSnapshot = await nivelesCollection.get();
      List<QueryDocumentSnapshot> nivelesDocs = nivelesSnapshot.docs;
      nivelesDocs.sort((a, b) => a['id'].compareTo(b['id']));
      List<Nivel> niveles = [];

      for (QueryDocumentSnapshot nivelDoc in nivelesDocs) {
        int nivelId = nivelDoc['id'] ?? 0; // Obtener el campo "id"
        String nivelNombre = nivelDoc['nombre'] ?? '';
        List<Subnivel> subniveles = [];

        ////////////SUBNIVELES///////////
        CollectionReference subnivelesCollection =
            nivelDoc.reference.collection('subniveles');
        QuerySnapshot subnivelesSnapshot = await subnivelesCollection.get();
        List<QueryDocumentSnapshot> subnivelesDocs = subnivelesSnapshot.docs;
        subnivelesDocs.sort((a, b) => a['id'].compareTo(b['id']));
        for (QueryDocumentSnapshot subnivelDoc in subnivelesDocs) {
          int subnivelId = subnivelDoc['id'] ?? 0;
          String urlImage = subnivelDoc['imagen'] ?? '';
          bool subnivelAprobado = subnivelDoc['subnivelAprobado'] ?? false;
          String subnivelNombre = subnivelDoc['nombre'] ?? '';
          List<Leccion> lecciones = [];

          ////////////LECCIONES///////////
          CollectionReference leccionesCollection =
              subnivelDoc.reference.collection('lecciones');
          QuerySnapshot leccionesSnapshot = await leccionesCollection.get();
          List<QueryDocumentSnapshot> leccionesDocs = leccionesSnapshot.docs;
          leccionesDocs.sort((a, b) => a['id'].compareTo(b['id']));
          for (QueryDocumentSnapshot leccionDoc in leccionesDocs) {
            // Obtener los datos de la lección y crear un objeto Leccion
            int idLeccion = leccionDoc['id'] ?? 0;
            String leccionNombre = leccionDoc['nombre'] ?? '';
            String identificador = leccionDoc['identificador'] ?? '';
            String imageUrl = leccionDoc['imageUrl']?.toString() ?? '';

            CollectionReference preguntasCollection =
                leccionDoc.reference.collection('preguntas');
            QuerySnapshot preguntasSnapshot = await preguntasCollection.get();
            List<QueryDocumentSnapshot> preguntasDocs = preguntasSnapshot.docs;

            preguntasDocs.sort((a, b) => a['id'].compareTo(b['id']));

            //////////////PREGUNTAS////////////////
            List<Pregunta> preguntas = [];
            for (QueryDocumentSnapshot preguntaDoc in preguntasDocs) {
              List<String> opciones = [];
              List<dynamic> opcionesList = [];
              int idPregunta = preguntaDoc['id'];
              //String idLeccion = leccionDoc['identificador'];
              String enunciadoPregunta = preguntaDoc['enunciado'] ?? '';
              String imagenPregunta = preguntaDoc['imagen'] ?? '';
              int respuesta = preguntaDoc['respuesta'] ?? '';
              String tipo = preguntaDoc['tipo'] ?? '';
              opcionesList = preguntaDoc['opciones'] ?? [];
              opciones.addAll(opcionesList.cast<String>());

              Pregunta pregunta = Pregunta(
                id: idPregunta,
                // idLeccion: idLeccion,
                imagen: imagenPregunta,
                enunciado: enunciadoPregunta,
                opciones: opciones,
                respuestaCorrecta: respuesta,
                tipo: tipo,
              );

              preguntas.add(pregunta);
            }
            Leccion leccion = Leccion(
              id: idLeccion,
              nombre: leccionNombre,
              preguntas: preguntas,
              imageUrl: imageUrl,
              identificador: identificador,
            );
            lecciones.add(leccion);
          }

          Subnivel subnivel = Subnivel(
            id: subnivelId,
            nombre: subnivelNombre,
            lecciones: lecciones,
            urlImage: urlImage,
            subnivelAprobado: subnivelAprobado,
          );
          subniveles.add(subnivel);
        }

        Nivel nivel = Nivel(
          id: nivelId,
          nombre: nivelNombre,
          subniveles: subniveles,
        );
        niveles.add(nivel);
      }

      return niveles;
    } catch (error) {
      print('Error al obtener los niveles desde Firebase: $error');
      return []; // Devolver una lista vacía en caso de error
    }
  }

  String serializeNiveles(List<Nivel> niveles) {
    List<Map<String, dynamic>> serializedNiveles = [];

    for (Nivel nivel in niveles) {
      Map<String, dynamic> serializedNivel = {
        'id': nivel.id,
        'nombre': nivel.nombre,
        'subniveles': serializeSubniveles(nivel.subniveles),
      };

      serializedNiveles.add(serializedNivel);
    }

    return json.encode(serializedNiveles);
  }

  List<Map<String, dynamic>> serializeSubniveles(List<Subnivel> subniveles) {
    List<Map<String, dynamic>> serializedSubniveles = [];

    for (Subnivel subnivel in subniveles) {
      Map<String, dynamic> serializedSubnivel = {
        'id': subnivel.id,
        'nombre': subnivel.nombre,
        'urlImage': subnivel.urlImage,
        'lecciones': serializeLecciones(subnivel.lecciones),
      };

      serializedSubniveles.add(serializedSubnivel);
    }

    return serializedSubniveles;
  }

  List<Map<String, dynamic>> serializeLecciones(List<Leccion> lecciones) {
    List<Map<String, dynamic>> serializedLecciones = [];

    for (Leccion leccion in lecciones) {
      Map<String, dynamic> serializedLeccion = {
        'id': leccion.id,
        'nombre': leccion.nombre,
        'identificador': leccion.identificador,
        'preguntas': serializePreguntas(leccion.preguntas),
      };

      serializedLecciones.add(serializedLeccion);
    }

    return serializedLecciones;
  }

  List<Map<String, dynamic>> serializePreguntas(List<Pregunta> preguntas) {
    List<Map<String, dynamic>> serializedPreguntas = [];

    for (Pregunta pregunta in preguntas) {
      Map<String, dynamic> serializedPregunta = {
        'id': pregunta.id,
        'imagen': pregunta.imagen,
        'enunciado': pregunta.enunciado,
        'opciones': pregunta.opciones,
        'respuesta': pregunta.respuestaCorrecta,
        'tipo': pregunta.tipo,
      };

      serializedPreguntas.add(serializedPregunta);
    }

    return serializedPreguntas;
  }

  List<Nivel> parseCachedData(String cachedData) {
    // Parsear los datos almacenados en la caché y retornarlos como una lista de Nivel
    // Implementa la lógica de parseo según el formato de datos que hayas elegido para la caché
    // Decodificar la cadena JSON
    List<dynamic> jsonData = jsonDecode(cachedData);

    // Crear una lista de objetos Nivel a partir de los datos decodificados
    List<Nivel> niveles = [];
    for (dynamic nivelData in jsonData) {
      int nivelId = nivelData['id'];
      String nivelNombre = nivelData['nombre'];

      // Parsear los subniveles y lecciones de nivelData, de manera similar a como se hizo en getNiveles()
      // ...
      List<Subnivel> subniveles = parseSubniveles(nivelData);
      Nivel nivel =
          Nivel(id: nivelId, nombre: nivelNombre, subniveles: subniveles);
      niveles.add(nivel);
    }

    return niveles;
  }

  List<Subnivel> parseSubniveles(dynamic nivelData) {
    List<Subnivel> subniveles = [];

    // Obtener los datos de los subniveles de nivelData, suponiendo que están almacenados en un campo llamado "subniveles"
    List<dynamic> subnivelesData = nivelData['subniveles'];

    for (dynamic subnivelData in subnivelesData) {
      int subnivelId = subnivelData['id'];
      String subnivelNombre = subnivelData['nombre'];
      String urlImage = subnivelData['urlImage'];

      // Parsear las lecciones de subnivelData, de manera similar a como se hizo en getNiveles()
      List<Leccion> lecciones = parseLecciones(subnivelData);

      Subnivel subnivel = Subnivel(
        id: subnivelId,
        nombre: subnivelNombre,
        lecciones: lecciones,
        urlImage: urlImage,
      );

      subniveles.add(subnivel);
    }

    return subniveles;
  }

  List<Leccion> parseLecciones(dynamic subnivelData) {
    List<Leccion> lecciones = [];

    // Obtener los datos de las lecciones de subnivelData, suponiendo que están almacenados en un campo llamado "lecciones"
    List<dynamic> leccionesData = subnivelData['lecciones'];

    for (dynamic leccionData in leccionesData) {
      String idLeccion = leccionData['identificador'];
      String leccionNombre = leccionData['nombre'];

      // Parsear las preguntas de leccionData, de manera similar a como se hizo en getNiveles()
      List<Pregunta> preguntas = parsePreguntas(leccionData);

      Leccion leccion = Leccion(
        identificador: idLeccion,
        nombre: leccionNombre,
        preguntas: preguntas,
      );

      lecciones.add(leccion);
    }

    return lecciones;
  }

  List<Pregunta> parsePreguntas(dynamic leccionData) {
    List<Pregunta> preguntas = [];

    // Obtener los datos de las preguntas de leccionData, suponiendo que están almacenados en un campo llamado "preguntas"
    List<dynamic> preguntasData = leccionData['preguntas'];

    for (dynamic preguntaData in preguntasData) {
      // Parsear los datos de la pregunta, de manera similar a como se hizo en getNiveles()
      // ...
      List<String> opciones = [];
      List<dynamic> opcionesList = [];

      opcionesList = preguntaData['opciones'];
      opciones.addAll(opcionesList.cast<String>());
      Pregunta pregunta = Pregunta(
        id: preguntaData['id'],
        imagen: preguntaData['imagen'],
        enunciado: preguntaData['enunciado'],
        opciones: opciones,
        respuestaCorrecta: preguntaData['respuesta'],
        tipo: preguntaData['tipo'],
      );

      preguntas.add(pregunta);
    }

    return preguntas;
  }
}
