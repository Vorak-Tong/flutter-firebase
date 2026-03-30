import 'package:flutter/material.dart';

import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/comments/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  final TextEditingController commentController = TextEditingController();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artist,
  }) {
    fetchData();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> fetchData({bool forceFetch = false}) async {
    songsValue = AsyncValue.loading();
    commentsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final List<Song> songs = await artistRepository.fetchArtistSongs(
        artist.id,
        forceFetch: forceFetch,
      );
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }

    try {
      final List<Comment> comments = await artistRepository.fetchArtistComments(
        artist.id,
        forceFetch: forceFetch,
      );
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> onRefresh() async {
    await fetchData(forceFetch: true);
  }

  Future<void> addComment() async {
    final String message = commentController.text.trim();

    if (message.isEmpty) {
      return;
    }

    try {
      final Comment newComment = await artistRepository.postArtistComment(
        artist.id,
        message,
      );

      final List<Comment> currentComments = commentsValue.data ?? [];
      commentsValue = AsyncValue.success([...currentComments, newComment]);

      commentController.clear();
      notifyListeners();
    } catch (e) {
      commentsValue = AsyncValue.error(e);
      notifyListeners();
    }
  }
}
