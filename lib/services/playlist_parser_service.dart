import 'dart:convert';
import 'package:amazon_music_playlist_parser/models/playlist_model.dart';
import '../models/song_model.dart';
import 'package:http/http.dart' as http;

class PlaylistParserService {
  Future<Playlist> parsePlaylist(String url) async {
    final String mockApiUrl = "https://api.jsonbin.io/v3/b/691527d5ae596e708f55a750";

    final Map<String, String> headers = {
      'X-Access-Key': "\$2a\$10\$4AIw7XxkeQHTJttQkz2NN.soQlueEMZ42cB4Nc8n24L.keTohqyeC"
    };

    try {
      final response = await http.get(
        Uri.parse(mockApiUrl),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load Mock API. Status code: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> record = data['record'];

      final template = record['template'];

      final String playlistTitle = template['headerText']['text'] ?? 'No Title';
      final String playlistDescription =
          template['headerSecondaryText'] ?? 'No Description';
      final String imageUrl = template['headerImage'] ?? '';

      List<Song> songs = [];
      final widgetList = record['widgets'] as List;
      final songWidget = widgetList[0];
      final songItems = songWidget['items'] as List;

      for (var item in songItems) {
        final String name = item['primaryText'] ?? 'No Name';
        final String artist = item['secondaryText1'] ?? 'No Artist';
        final String album = item['secondaryText2'] ?? 'No Album';
        final String duration = item['secondaryText3'] ?? '0:00';

        final song = Song(
          name: name,
          artist: artist,
          album: album,
          duration: duration,
        );
        songs.add(song);
      }

      return Playlist(
        title: playlistTitle,
        imgUrl: imageUrl,
        description: playlistDescription,
        songs: songs,
      );
    } catch (e) {
      throw Exception('Failed to parse playlist: $e');
    }
  }
}
