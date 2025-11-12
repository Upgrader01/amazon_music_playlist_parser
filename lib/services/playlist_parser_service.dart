import 'package:amazon_music_playlist_parser/models/playlist_model.dart';
import '../models/song_model.dart';

class PlaylistParserService {
  Future<Playlist> parsePlaylist(String url) async {
    List<Song> fakeSongs = [
      const Song(
        name: "Bohemian Rhapsody",
        artist: "Queen",
        album: "A Night at the Opera",
        duration: "5:55",
      ),
      const Song(
        name: "Stairway to Heaven",
        artist: "Led Zeppelin",
        album: "Led Zeppelin IV",
        duration: "8:02",
      ),
      const Song(
        name: "Hotel California",
        artist: "Eagles",
        album: "Hotel California",
        duration: "6:30",
      ),
    ];

    Playlist fakePlaylist = Playlist(
      title: "Playlist1",
      imgUrl: "https://m.media-amazon.com/images/I/51V-kcyaMBL._UX358_FMwebp_QL85_.jpg",
      description: "description1",
      songs: fakeSongs,
    );

    await Future.delayed(const Duration(seconds: 2));

    return fakePlaylist;
  }
}
