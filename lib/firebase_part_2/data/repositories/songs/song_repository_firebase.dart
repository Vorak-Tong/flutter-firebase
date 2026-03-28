import 'dart:convert';

import 'package:flutter_firebase/firebase_part_2/config/firebase_config.dart';
import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = FirebaseConfig.baseUrl.replace(path: '/songs.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> songJson = json.decode(response.body);

      final List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(
          SongDto.fromJson(
            entry.key,
            Map<String, dynamic>.from(entry.value),
          ),
        );
      }
      return result;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

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
      return song.copyWith(likes: newLikes);
    } else {
      throw Exception('Failed to like song');
    }
  }
}
