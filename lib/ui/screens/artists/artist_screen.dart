import 'package:flutter/material.dart';
import 'package:flutter_firebase/data/repositories/artists/artist_repository.dart';
import 'package:provider/provider.dart';
import 'view_model/artist_view_model.dart';
import '../../states/player_state.dart';
import 'widgets/artist_content.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistViewModel(
        playerState: context.read<PlayerState>(),
        artistRepository: context.read<ArtistRepository>(),
      ),
      child: ArtistContent(),
    );
  }
}
