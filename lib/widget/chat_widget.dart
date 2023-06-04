import 'package:flutter/material.dart';

/// Chatの内容を表示するクラス
class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.message,
    this.onTap,
    this.margin,
  });

  /// メッセージ
  final String message;

  /// タップイベント
  final Function()? onTap;

  /// マージン
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Container(
          margin:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Text(message,
              overflow: TextOverflow.clip,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
        ),
      ),
    );
  }
}
