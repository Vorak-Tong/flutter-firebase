import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_part_2/model/settings/app_settings.dart';
import 'package:flutter_firebase/firebase_part_2/ui/states/settings_state.dart';
import 'package:provider/provider.dart';

import '../../../../model/artist/artist.dart';
import '../../../../model/comments/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../view_model/artist_detail_view_model.dart';
import 'comment_form.dart';
import 'comment_tile.dart';

class ArtistDetailContent extends StatelessWidget {
  const ArtistDetailContent({super.key, required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    final ArtistDetailViewModel mv = context.watch<ArtistDetailViewModel>();

    final AsyncValue<List<Song>> songsValue = mv.songsValue;
    final AsyncValue<List<Comment>> commentsValue = mv.commentsValue;

    AppSettingsState settingsState = context.watch<AppSettingsState>();

    Widget songsSection;
    switch (songsValue.state) {
      case AsyncValueState.loading:
        songsSection = const Center(child: CircularProgressIndicator());
        break;

      case AsyncValueState.error:
        songsSection = Center(
          child: Text(
            'error = ${songsValue.error!}',
            style: const TextStyle(color: Colors.red),
          ),
        );
        break;

      case AsyncValueState.success:
        final List<Song> songs = songsValue.data!;
        if (songs.isEmpty) {
          songsSection = const Center(child: Text('No songs yet'));
        } else {
          songsSection = Column(
            children: songs
                .map(
                  (song) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(song.imageUrl.toString()),
                      ),
                      title: Text(song.title),
                      subtitle: Text('${song.duration.inMinutes} mins'),
                    ),
                  ),
                )
                .toList(),
          );
        }
        break;
    }

    Widget commentsSection;
    switch (commentsValue.state) {
      case AsyncValueState.loading:
        commentsSection = const Center(child: CircularProgressIndicator());
        break;

      case AsyncValueState.error:
        commentsSection = Center(
          child: Text(
            'error = ${commentsValue.error!}',
            style: const TextStyle(color: Colors.red),
          ),
        );
        break;

      case AsyncValueState.success:
        final List<Comment> comments = commentsValue.data!;
        if (comments.isEmpty) {
          commentsSection = const Center(child: Text('No comments yet'));
        } else {
          commentsSection = Column(
            children: comments
                .map((comment) => CommentTile(comment: comment))
                .toList(),
          );
        }
        break;
    }

    return Scaffold(
      backgroundColor: settingsState.theme.backgroundColor,
      appBar: AppBar(title: Text(artist.name)),
      body: RefreshIndicator(
        onRefresh: mv.onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(artist.imageUrl.toString()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '${artist.name}\n${artist.genre}',
                    style: AppTextStyles.title,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Songs', style: AppTextStyles.title),
            const SizedBox(height: 12),
            songsSection,
            const SizedBox(height: 24),
            Text('Comments', style: AppTextStyles.title),
            const SizedBox(height: 12),
            commentsSection,
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: CommentForm(
        controller: mv.commentController,
        onSubmit: mv.addComment,
      ),
    );
  }
}
