import './song_model.dart';

class Playlist {
  final String title;
  final String imgUrl;
  final String description;
  final List<Song> songs;

  const Playlist({
    required this.title,
    required this.imgUrl,
    required this.description,
    required this.songs,
  });
}
