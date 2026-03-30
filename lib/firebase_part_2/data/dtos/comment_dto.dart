import '../../model/comments/comment.dart';

class CommentDto {
  static const String artistIdKey = 'artistId';
  static const String messageKey = 'message';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    if (json[artistIdKey] is! String) {
      throw Exception('Invalid comment artistId for id=$id: $json');
    }
    if (json[messageKey] is! String) {
      throw Exception('Invalid comment message for id=$id: $json');
    }

    return Comment(
      id: id,
      artistId: json[artistIdKey],
      message: json[messageKey],
    );
  }

  Map<String, dynamic> toJson(Comment comment) {
    return {artistIdKey: comment.artistId, messageKey: comment.message};
  }
}
