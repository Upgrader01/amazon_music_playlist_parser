import 'package:amazon_music_playlist_parser/models/playlist_model.dart';
import 'package:amazon_music_playlist_parser/services/playlist_parser_service.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatefulWidget {
  final String url;
  const PlaylistScreen({super.key, required this.url});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Playlist? _playlist;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    _fetchPlaylist();
    super.initState();
  }

  Future<void> _fetchPlaylist() async {
    final parser = PlaylistParserService();

    try {
      final playlist = await parser.parsePlaylist(widget.url);

      setState(() {
        _playlist = playlist;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    if (_isLoading) {
      bodyWidget = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      bodyWidget = Center(
        child: Text(
          "ERROR: $_error",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    } else if (_playlist != null) {
      bodyWidget = buildPlaylistView();
    } else {
      bodyWidget = const Center(child: Text('Something went wrong('));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Palylist Details')),
      body: bodyWidget,
    );
  }

  Column buildPlaylistView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(_playlist!.imgUrl),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: [
                      Text(
                        _playlist!.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _playlist!.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Divider(color: Colors.grey[800], height: 1),

        Expanded(
          child: ListView.builder(
            itemCount: _playlist!.songs.length,
            itemBuilder: (context, index) {
              final song = _playlist!.songs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Text(
                    song.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${song.artist} - ${song.album}'),
                  trailing: Text(
                    song.duration,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  leading: CircleAvatar(child: Image.network(_playlist!.imgUrl)),
                  tileColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(26),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
