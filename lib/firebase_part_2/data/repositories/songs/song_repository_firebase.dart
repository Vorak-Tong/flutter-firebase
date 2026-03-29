import 'dart:convert';

import 'package:flutter_firebase/firebase_part_2/config/firebase_config.dart';
import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = FirebaseConfig.baseUrl.replace(path: '/songs.json');

  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> songJson = json.decode(response.body);

      final List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(
          SongDto.fromJson(entry.key, Map<String, dynamic>.from(entry.value)),
        );
      }

      _cachedSongs = result;
      return result;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final List<Song> songs = await fetchSongs();
    try {
      return songs.firstWhere((song) => song.id == id);
    } catch (e) {
      throw Exception("Failed to load songs");
    }
  }

  @override
  Future<Song> likeSong(Song song) async {
    final Uri songUri = FirebaseConfig.baseUrl.replace(
      path: '/songs/${song.id}.json',
    );

    final int newLikes = song.likes + 1;

    final http.Response response = await http.patch(
      songUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'likes': newLikes}),
    );

    if (response.statusCode == 200) {
      final Song updatedSong = song.copyWith(likes: newLikes);

      if (_cachedSongs != null) {
        final List<Song> updatedSongs = [];

        for (final cachedSong in _cachedSongs!) {
          if (cachedSong.id == updatedSong.id) {
            updatedSongs.add(updatedSong);
          } else {
            updatedSongs.add(cachedSong);
          }
        }

        _cachedSongs = updatedSongs;
      }
      return updatedSong;
    } else {
      throw Exception('Failed to like song');
    }
  }
}
