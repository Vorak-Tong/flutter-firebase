class Comment {
  final String id;
  final String artistId;
  final String message;

  Comment({required this.id, required this.artistId, required this.message});

  @override
  String toString() {
    return 'Comment(id: $id, artistId: $artistId, message: $message)';
  }
}
