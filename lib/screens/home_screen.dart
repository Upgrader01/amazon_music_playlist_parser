import 'package:amazon_music_playlist_parser/screens/playlist_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amazon Playlist Parser')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL playlist',
                hintText: 'https://music.amazon.com/...',
              ),
              keyboardType: TextInputType.url,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                final url = _urlController.text;
                if (url.isEmpty) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaylistScreen(url: url),
                  ),
                );
              },
              child: Text('Start parsing'),
            ),

            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
