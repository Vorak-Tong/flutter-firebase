import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artists/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase extends ArtistRepository{
  final Uri artistsUri = Uri.https(
    'week-8-practice-78767-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistsUri);

    if(response.statusCode == 200){
      Map<String, dynamic> artistJson = json.decode(response.body);
      List<Artist> artists = [];

      for(var key in artistJson.keys){
        var data = artistJson[key];
        artists.add(ArtistDto.fromJson(key, data));
      }
      return artists;
    } else {
      throw Exception("Falied to load artists");
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) {
    throw UnimplementedError();
  }
}