import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_part_1/data/repositories/artists/artist_repository.dart';
import 'package:flutter_firebase/firebase_part_1/model/artists/artist.dart';
import 'package:flutter_firebase/firebase_part_1/model/songs/song_with_artist.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;

  AsyncValue<List<SongWithArtist>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<Song> songs = await songRepository.fetchSongs();
      List<Artist> artists = await artistRepository.fetchArtists();

      final Map<String, Artist> artistById = {};

      for (final artist in artists) {
        artistById[artist.id] = artist;
      }

      final List<SongWithArtist> songsWithArtists = [];

      for (final song in songs) {
        final Artist? artist = artistById[song.artistId];

        songsWithArtists.add(SongWithArtist(song: song, artist: artist));
      }

      songsValue = AsyncValue.success(songsWithArtists);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
