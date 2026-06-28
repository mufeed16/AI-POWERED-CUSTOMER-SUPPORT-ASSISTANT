import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/hotel_widget.dart';
import '../widgets/flight_widget.dart';
import '../widgets/tracking_widget.dart';
import '../widgets/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void _sendMessage(ChatProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    provider.sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Customer Support'), backgroundColor: Theme.of(context).colorScheme.inversePrimary, actions: [IconButton(icon: const Icon(Icons.refresh), tooltip: 'Reset', onPressed: () => context.read<ChatProvider>().clearHistory())]),
    body: Column(children: [
      Expanded(child: Consumer<ChatProvider>(builder: (context, provider, _) {
        if (provider.messages.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.support_agent, size: 80, color: Colors.grey.shade300), const SizedBox(height: 16), Text('How can I help you today?', style: TextStyle(fontSize: 18, color: Colors.grey.shade500)), const SizedBox(height: 8), Text('Try: "Show hotels in Dubai" or "Track my order"', style: TextStyle(color: Colors.grey.shade400))]));
        return ListView.builder(controller: _scrollController, padding: const EdgeInsets.all(16), itemCount: provider.messages.length, itemBuilder: (context, index) => _buildMessageBubble(provider.messages[index]));
      })),
      Consumer<ChatProvider>(builder: (context, provider, _) => provider.errorMessage != null ? Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), color: Colors.red.shade50, child: Row(children: [Icon(Icons.error_outline, color: Colors.red.shade700), const SizedBox(width: 8), Expanded(child: Text(provider.errorMessage!, style: TextStyle(color: Colors.red.shade700)))])) : const SizedBox.shrink()),
      Consumer<ChatProvider>(builder: (context, provider, _) => provider.isLoading ? const LinearProgressIndicator() : const SizedBox.shrink()),
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]), child: SafeArea(child: Row(children: [
        Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: 'Type your message...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), onSubmitted: (_) => _sendMessage(context.read<ChatProvider>()))),
        const SizedBox(width: 8),
        Consumer<ChatProvider>(builder: (context, provider, _) => IconButton.filled(onPressed: provider.isLoading ? null : () => _sendMessage(provider), icon: provider.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send)))
      ])))
    ]),
  );

  Widget _buildMessageBubble(dynamic message) {
    final isUser = message.role == 'user';
    return Align(alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(color: isUser ? Colors.blue : Colors.grey.shade100, borderRadius: BorderRadius.circular(16).copyWith(bottomRight: isUser ? const Radius.circular(4) : null, bottomLeft: !isUser ? const Radius.circular(4) : null)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(message.content, style: TextStyle(color: isUser ? Colors.white : Colors.black87)),
        if (!isUser && message.uiType != null && message.data != null) ...[const SizedBox(height: 12), _buildDynamicWidget(message.uiType!, message.data!)],
      ]),
    ));
  }

  Widget _buildDynamicWidget(String uiType, Map<String, dynamic> data) {
    switch (uiType) {
      case 'hotel_page': return HotelWidget(data: data);
      case 'flight_page': return FlightWidget(data: data);
      case 'tracking_page': return TrackingWidget(data: data);
      case 'refund_form':
      case 'complaint_form':
      case 'form': return MessageWidget(message: data['message'] ?? data['response'] ?? '');
      case 'message':
      default: return MessageWidget(message: data['message'] ?? data['response'] ?? '');
    }
  }
}