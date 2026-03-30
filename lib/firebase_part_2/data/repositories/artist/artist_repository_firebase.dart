import 'dart:convert';

import 'package:flutter_firebase/firebase_part_2/config/firebase_config.dart';
import 'package:http/http.dart' as http;

import '../../../model/artist/artist.dart';
import '../../../model/comments/comment.dart';
import '../../../model/songs/song.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/comment_dto.dart';
import '../../dtos/song_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistsUri = FirebaseConfig.baseUrl.replace(path: '/artists.json');
  final Uri songsUri = FirebaseConfig.baseUrl.replace(path: '/songs.json');
  final Uri commentsUri = FirebaseConfig.baseUrl.replace(
    path: '/comments.json',
  );

  List<Artist>? _cachedArtists;
  List<Song>? _cachedSongs;
  List<Comment>? _cachedComments;

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (!forceFetch && _cachedArtists != null) {
      return _cachedArtists!;
    }

    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> artistJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in artistJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }

      _cachedArtists = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final List<Artist> artists = await fetchArtists();
    try {
      return artists.firstWhere((artist) => artist.id == id);
    } catch (e) {
      throw Exception("Failed to load artists");
    }
  }

  @override
  Future<List<Song>> fetchArtistSongs(
    String artistId, {
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _cachedSongs != null) {
      List<Song> artistSongs = [];

      for (final song in _cachedSongs!) {
        if (song.artistId == artistId) {
          artistSongs.add(song);
        }
      }
      return artistSongs;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(
          SongDto.fromJson(entry.key, Map<String, dynamic>.from(entry.value)),
        );
      }

      _cachedSongs = result;

      List<Song> artistSongs = [];
      for (final song in result) {
        if (song.artistId == artistId) {
          artistSongs.add(song);
        }
      }

      return artistSongs;
    } else {
      throw Exception('Failed to load artist songs');
    }
  }

  @override
  Future<List<Comment>> fetchArtistComments(
    String artistId, {
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _cachedComments != null) {
      List<Comment> artistComments = [];

      for (final comment in _cachedComments!) {
        if (comment.artistId == artistId) {
          artistComments.add(comment);
        }
      }

      return artistComments;
    }

    final http.Response response = await http.get(commentsUri);

    if (response.statusCode == 200) {
      if (response.body == 'null') {
        _cachedComments = [];
        return [];
      }

      final Map<String, dynamic> commentJson = json.decode(response.body);

      List<Comment> result = [];
      for (final entry in commentJson.entries) {
        result.add(
          CommentDto.fromJson(
            entry.key,
            Map<String, dynamic>.from(entry.value),
          ),
        );
      }

      _cachedComments = result;

      List<Comment> artistComments = [];
      for (final comment in result) {
        if (comment.artistId == artistId) {
          artistComments.add(comment);
        }
      }

      return artistComments;
    } else {
      throw Exception('Failed to load artist comments');
    }
  }

  @override
  Future<Comment> postArtistComment(String artistId, String message) async {
    final http.Response response = await http.post(
      commentsUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'artistId': artistId, 'message': message}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      final String id = responseJson['name'];

      final Comment newComment = Comment(
        id: id,
        artistId: artistId,
        message: message,
      );

      if (_cachedComments != null) {
        _cachedComments!.add(newComment);
      }

      return newComment;
    } else {
      throw Exception('Failed to post comment');
    }
  }
}
