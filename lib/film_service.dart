import 'package:cloud_firestore/cloud_firestore.dart';
import 'film_model.dart';

class FilmService {
  final CollectionReference filmCollection =
      FirebaseFirestore.instance.collection('films');

  Future<void> addFilm(Film film) {
    return filmCollection.add(film.toMap());
  }

  Future<void> updateFilm(Film film) {
    return filmCollection.doc(film.id).update(film.toMap());
  }

  Future<void> deleteFilm(String id) {
    return filmCollection.doc(id).delete();
  }

  Stream<List<Film>> getFilms() {
    return filmCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Film.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
}
