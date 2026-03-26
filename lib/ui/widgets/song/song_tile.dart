import 'package:flutter/material.dart';

import '../../../model/songs/song.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song,
    required this.artistName,
    required this.artistGenre,
    required this.isPlaying,
    required this.onTap,
  });

  final Song song;
  final String artistName;
  final String artistGenre;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(song.imageUrl.toString()),),
          onTap: onTap,
          title: Text(song.title),
          subtitle: Text(
            '${song.duration.inMinutes} mins | $artistName - $artistGenre',
          ),
          trailing: Text(
            isPlaying ? "Playing" : "",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ),
    );
  }
}
