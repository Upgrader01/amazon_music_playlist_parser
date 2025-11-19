import 'package:flutter/material.dart';
import '../models/playlist_model.dart';
import '../services/playlist_parser_service.dart';
import '../widgets/hidden_webview.dart';
import '../widgets/playlist_header.dart';
import '../widgets/song_list_item.dart';

class PlaylistScreen extends StatefulWidget {
  final String url;
  const PlaylistScreen({super.key, required this.url});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final _parserService = PlaylistParserService();
  Playlist? _playlist;
  bool _isLoading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _playlist?.title ?? 'Loading...',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Stack(
        children: [
          HiddenWebView(url: widget.url, onHtmlLoaded: _onHtmlReceived),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Error: $_error",
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else if (_playlist != null)
            Column(
              children: [
                PlaylistHeader(playlist: _playlist!),

                Divider(color: Colors.grey[800], height: 1),

                Expanded(
                  child: ListView.builder(
                    itemCount: _playlist!.songs.length,
                    itemBuilder: (context, index) {
                      return SongListItem(song: _playlist!.songs[index]);
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onHtmlReceived(String html) {
    try {
      final playlist = _parserService.parseHtml(html);

      if (mounted) {
        setState(() {
          _playlist = playlist;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }
}
