import '../artists/artist.dart';
import 'song.dart';

class SongWithArtist {
  final Song song;
  final Artist? artist;

  SongWithArtist({
    required this.song,
    required this.artist,
  });
}