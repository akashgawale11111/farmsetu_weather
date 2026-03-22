import 'package:flutter/material.dart';
import 'package:farmsetu_weather/services/aiservice.dart';

class FarmerChatScreen extends StatefulWidget {
  const FarmerChatScreen({super.key});

  @override
  State<FarmerChatScreen> createState() => _FarmerChatScreenState();
}

class _FarmerChatScreenState extends State<FarmerChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool _isLoading = false;

  final AIService _aiService = AIService();

  // ✅ SEND MESSAGE
  void sendMessage([String? customText]) async {
    final text = (customText ?? _controller.text).trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });

    _controller.clear();

    try {
      String reply = await _aiService.sendMessage(text);

      setState(() {
        messages.add({'role': 'bot', 'text': reply});
      });
    } catch (e) {
      setState(() {
        messages.add({
          'role': 'bot',
          'text': "❌ Error: Unable to get response"
        });
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ✅ VOICE ASSISTANT
  void openVoiceAssistant() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("🎤 Voice Assistant"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic, size: 50, color: Colors.green),
            SizedBox(height: 10),
            Text("Listening... Speak your question")
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              sendMessage("How to protect crops from rain?");
            },
            child: const Text("Stop"),
          )
        ],
      ),
    );
  }

  // ✅ IMAGE PICKER (DEMO)
  void openImagePicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("📷 Upload Crop Photo"),
        content: const Text("Image selected successfully"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              sendMessage("Check this crop disease");
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // ✅ CHAT BUBBLE
  Widget buildMessage(Map<String, String> msg) {
    final isUser = msg['role'] == 'user';

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isUser ? Colors.green : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg['text'] ?? '',
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // ✅ UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.agriculture),
            SizedBox(width: 8),
            Text('Farmer AI Assistant 🌾'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // ✅ CHAT LIST
          Expanded(
            child: ListView.builder(
              itemCount: messages.length +
                  (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading &&
                    index == messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return buildMessage(messages[index]);
              },
            ),
          ),

          // ✅ INPUT AREA
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image,
                      color: Colors.green),
                  onPressed: openImagePicker,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText:
                          'Ask farming question...',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(
                              horizontal: 12),
                    ),
                    onSubmitted: (_) =>
                        !_isLoading ? sendMessage() : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic,
                      color: Colors.green),
                  onPressed: openVoiceAssistant,
                ),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Icon(Icons.send,
                        color: Colors.white),
                    onPressed: () =>
                        !_isLoading ? sendMessage() : null,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}