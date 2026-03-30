import 'package:flutter/material.dart';

class CommentForm extends StatelessWidget {
  const CommentForm({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: onSubmit, child: const Text('Comment')),
        ],
      ),
    );
  }
}
