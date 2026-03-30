import 'package:flutter/material.dart';

import '../../../../model/comments/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(comment.message),
        )
      ),
    );
  }
}
