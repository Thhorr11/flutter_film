import 'package:flutter/material.dart';
import 'film_service.dart';
import 'film_model.dart';

class FilmPage extends StatefulWidget {
  const FilmPage({super.key});

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  final FilmService _filmService = FilmService();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _direktorController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();

  void _showDialog({Film? film}) {
    if (film != null) {
      _idController.text = film.filmId.toString();
      _judulController.text = film.judul;
      _direktorController.text = film.direktor;
      _ratingController.text = film.rating.toString();
      _tahunController.text = film.tahunRilis.toString();
    } else {
      _idController.clear();
      _judulController.clear();
      _direktorController.clear();
      _ratingController.clear();
      _tahunController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(film == null ? 'Tambah Film' : 'Edit Film'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _idController, decoration: const InputDecoration(labelText: 'ID')),
              TextField(controller: _judulController, decoration: const InputDecoration(labelText: 'Judul')),
              TextField(controller: _direktorController, decoration: const InputDecoration(labelText: 'Direktor')),
              TextField(controller: _ratingController, decoration: const InputDecoration(labelText: 'Rating')),
              TextField(controller: _tahunController, decoration: const InputDecoration(labelText: 'Tahun Rilis')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final newFilm = Film(
                id: film?.id ?? '',
                filmId: int.tryParse(_idController.text) ?? 0,
                judul: _judulController.text,
                direktor: _direktorController.text,
                rating: double.tryParse(_ratingController.text) ?? 0.0,
                tahunRilis: int.tryParse(_tahunController.text) ?? 0,
              );

              if (film == null) {
                _filmService.addFilm(newFilm);
              } else {
                _filmService.updateFilm(newFilm);
              }

              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Film')),
      body: StreamBuilder<List<Film>>(
        stream: _filmService.getFilms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Terjadi kesalahan'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final films = snapshot.data!;
          return ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films[index];
              return ListTile(
                title: Text('${film.judul} (${film.tahunRilis})'),
                subtitle: Text('Direktor: ${film.direktor} | Rating: ${film.rating}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _showDialog(film: film)),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => _filmService.deleteFilm(film.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
