class Film {
  final String id; // Firestore Document ID
  final int filmId;
  final String judul;
  final String direktor;
  final double rating;
  final int tahunRilis;

  Film({
    required this.id,
    required this.filmId,
    required this.judul,
    required this.direktor,
    required this.rating,
    required this.tahunRilis,
  });

  factory Film.fromMap(Map<String, dynamic> data, String documentId) {
    return Film(
      id: documentId,
      filmId: data['Id'],
      judul: data['Judul'],
      direktor: data['Direktor'],
      rating: (data['Rating'] as num).toDouble(),
      tahunRilis: data['Tahun Rilis'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': filmId,
      'Judul': judul,
      'Direktor': direktor,
      'Rating': rating,
      'Tahun Rilis': tahunRilis,
    };
  }
}
