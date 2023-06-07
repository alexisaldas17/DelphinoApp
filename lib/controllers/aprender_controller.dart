import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delphino_app/models/preguntas.dart';
import 'package:delphino_app/models/subniveles.dart';
import '../models/lecciones.dart';
import '../models/niveles.dart';

class AprenderController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    CollectionReference nivelesCollection =
        FirebaseFirestore.instance.collection('niveles');

    QuerySnapshot nivelesSnapshot = await nivelesCollection.get();
    List<QueryDocumentSnapshot> nivelesDocs = nivelesSnapshot.docs;
    nivelesDocs.sort((a, b) =>
        a['id'].compareTo(b['id'])); // Ordenar los documentos por el campo "id"
    List<Nivel> niveles = [];

    for (QueryDocumentSnapshot nivelDoc in nivelesDocs) {
      int nivelId = nivelDoc['id']; // Obtener el campo "id"
      String nivelNombre = nivelDoc['nombre'];
      List<Subnivel> subniveles = [];
      ////////////SUBNIVELES///////////

      CollectionReference subnivelesCollection =
          nivelDoc.reference.collection('subniveles');
      QuerySnapshot subnivelesSnapshot = await subnivelesCollection.get();
      List<QueryDocumentSnapshot> subnivelesDocs = subnivelesSnapshot.docs;
      subnivelesDocs.sort((a, b) => a['id'].compareTo(b['id']));
      for (QueryDocumentSnapshot subnivelDoc in subnivelesDocs) {
        int subnivelId = subnivelDoc['id'];
        String urlImage = subnivelDoc['imagen'];

        String subnivelNombre = subnivelDoc['nombre'];
        List<Leccion> lecciones = [];

        ////////////LECCIONES///////////

        CollectionReference leccionesCollection =
            subnivelDoc.reference.collection('lecciones');
        QuerySnapshot leccionesSnapshot = await leccionesCollection.get();
        List<QueryDocumentSnapshot> leccionesDocs = leccionesSnapshot.docs;
        leccionesDocs.sort((a, b) => a['id'].compareTo(b['id']));
        for (QueryDocumentSnapshot leccionDoc in leccionesDocs) {
          // Obtener los datos de la lección y crear un objeto Leccion
          int idLeccion = leccionDoc['id'];
          String leccionNombre = leccionDoc['nombre'];

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
            String enunciadoPregunta = preguntaDoc['enunciado'];
            String imagenPregunta = preguntaDoc['imagen'];
            String respuesta = preguntaDoc['respuesta'];

            opcionesList = preguntaDoc['opciones'];
            opciones.addAll(opcionesList.cast<String>());

            Pregunta pregunta = Pregunta(
                id: idPregunta,
                imagen: imagenPregunta,
                enunciado: enunciadoPregunta,
                opciones: opciones,
                respuestaCorrecta: respuesta);

            preguntas.add(pregunta);

           
          }
           Leccion leccion = Leccion(
                id: idLeccion, nombre: leccionNombre, preguntas: preguntas);
            lecciones.add(leccion);
        }

        Subnivel subnivel = Subnivel(
            id: subnivelId,
            nombre: subnivelNombre,
            lecciones: lecciones,
            urlImage: urlImage);
        subniveles.add(subnivel);
      }

      Nivel nivel =
          Nivel(id: nivelId, nombre: nivelNombre, subniveles: subniveles);
      niveles.add(nivel);
    }

    return niveles;
  }
 
}
