import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isError;
  const MessageWidget({super.key, required this.message, this.isError = false});

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isError ? Colors.red.shade50 : Colors.grey.shade100, borderRadius: BorderRadius.circular(8), border: Border.all(color: isError ? Colors.red.shade200 : Colors.grey.shade300)), child: Row(children: [Icon(isError ? Icons.error_outline : Icons.info_outline, color: isError ? Colors.red : Colors.blue), const SizedBox(width: 8), Expanded(child: Text(message, style: TextStyle(color: isError ? Colors.red.shade700 : Colors.grey.shade800)))]));
}