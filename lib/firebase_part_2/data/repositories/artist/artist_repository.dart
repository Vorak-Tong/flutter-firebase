import '../../../model/artist/artist.dart';
import '../../../model/songs/song.dart';
import '../../../model/comments/comment.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});

  Future<Artist?> fetchArtistById(String id);

  // use to get only the songs of one selected artist
  Future<List<Song>> fetchArtistSongs(
    String artistId, {
    bool forceFetch = false,
  });

  Future<List<Comment>> fetchArtistComments(
    String artistId, {
    bool forceFetch = false,
  });

  Future<Comment> postArtistComment(String artistId, String message);
}
