import 'package:html/parser.dart' as parser;
import '../models/playlist_model.dart';
import '../models/song_model.dart';

class PlaylistParserService {
  Playlist parseHtml(String htmlContent) {
    try {
      final document = parser.parse(htmlContent);

      String playlistTitle = document.querySelector('title')?.text ?? '';
      String playlistDescription =
          document
              .querySelector('meta[name="description"]')
              ?.attributes['content'] ??
          '';

      if (playlistTitle.isEmpty) {
        playlistTitle =
            document
                .querySelector('meta[property="og:title"]')
                ?.attributes['content'] ??
            '';
      }
      if (playlistDescription.isEmpty) {
        playlistDescription =
            document
                .querySelector('meta[property="og:description"]')
                ?.attributes['content'] ??
            '';
      }

      playlistTitle = _cleanText(playlistTitle);
      playlistDescription = _cleanText(playlistDescription);
      if (playlistTitle.isEmpty) playlistTitle = 'Unknown Playlist';

      String rawImageUrl =
          document
              .querySelector('meta[property="og:image"]')
              ?.attributes['content'] ??
          '';

      if (rawImageUrl.isEmpty) {
        final regex = RegExp(r'https://m\.media-amazon\.com/images/I/[a-zA-Z0-9._-]+\.jpg');
        final match = regex.firstMatch(htmlContent);
        if (match != null) {
          rawImageUrl = match.group(0)!;
        }
      }

      final String imageUrl = _getHdImageUrl(rawImageUrl);

      List<Song> songs = [];
      final songElements = document.querySelectorAll('[primary-text]');

      for (var element in songElements) {
        try {
          final attributes = element.attributes;

          final String name = attributes['primary-text']?.trim() ?? 'Unknown';
          final String artist =
              attributes['secondary-text-1']?.trim() ?? 'Unknown';
          final String album =
              attributes['secondary-text-2']?.trim() ?? 'Unknown';

          if (name.contains("Curated by") ||
              name.contains(playlistTitle) ||
              name == 'Unknown' ||
              artist == 'Unknown') {
            continue;
          }

          String duration = '--:--';
          final textContent = element.text;
          final timeMatch = RegExp(r'\d+:\d{2}').firstMatch(textContent);
          if (timeMatch != null) duration = timeMatch.group(0)!;

          final String rawSongImage = attributes['image-src'] ?? '';
          final String songImage = _getHdImageUrl(rawSongImage);

          songs.add(
            Song(
              name: name,
              artist: artist,
              album: album,
              duration: duration,
              imageUrl: songImage,
            ),
          );
        } catch (e) {
          print('Error parsing song: $e');
        }
      }

      return Playlist(
        title: playlistTitle,
        imgUrl: imageUrl,
        description: playlistDescription,
        songs: songs,
      );
    } catch (e) {
      throw Exception('Error parsing HTML: $e');
    }
  }

  String _getHdImageUrl(String url) {
    if (url.isEmpty) return '';
    return url.replaceAll(RegExp(r'\._[a-zA-Z0-9,_-]+_'), '');
  }

  String _cleanText(String text) {
    String cleaned = text.replaceAll('Playlist on Amazon Music Unlimited', '');

    const cutOffPhrase = "Listen to the ";
    if (cleaned.contains(cutOffPhrase)) {
      cleaned = cleaned.split(cutOffPhrase).first;
    }

    return cleaned.trim();
  }
}
