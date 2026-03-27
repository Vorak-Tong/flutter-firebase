import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_part_1/model/songs/song_with_artist.dart';

// import '../../../model/songs/song.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songWithArtist,
    required this.isPlaying,
    required this.onTap,
  });

  final SongWithArtist songWithArtist;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final artistName = songWithArtist.artist?.name ?? 'Unknown Artist';
    final artistGenre = songWithArtist.artist?.genre ?? 'Unknown Genre';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(songWithArtist.song.imageUrl.toString()),),
          onTap: onTap,
          title: Text(songWithArtist.song.title),
          subtitle: Text(
            '${songWithArtist.song.duration.inMinutes} mins | $artistName - $artistGenre',
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
