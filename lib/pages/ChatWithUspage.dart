import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final gemini = Gemini.instance;

  bool _isSending = false;
  int selectedIndex = 5;

  @override
  void initState() {
    super.initState();
    
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': userMessage});
      _controller.clear();
      _isSending = true;
    });

  try {
  final response = await gemini.text(userMessage);
  final botReply = response?.output ?? 'No response from Gemini.';

  setState(() {
    _messages.add({'sender': 'bot', 'text': botReply});
  });
} catch (e) {
  setState(() {
    _messages.add({'sender': 'bot', 'text': 'Sorry, something went wrong.'});
  });
} finally {
  setState(() {
    _isSending = false;
  });
}


  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue.shade600 : Colors.lightBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message['text'] ?? '',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? Colors.white : Colors.black87,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.white : Colors.black87,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.chat, color: Colors.white),
          ),
        ),
        title:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CarCare Bot', style: TextStyle(color: isDark ? Colors.black : Colors.white ),),
            Text('Welcome to our Live Chat!', style: TextStyle(fontSize: 12, color: isDark ? Colors.black : Colors.white )),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon:  Icon(Icons.menu, color: isDark ? Colors.black : Colors.white ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          )
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color :isDark ? Colors.black : Colors.white ),
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle( color :isDark ? Colors.black : Colors.white  ),
                      filled: true,
                      fillColor: isDark ? Colors.white : Colors.black87,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.blue.shade400,  ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.blue.shade400,),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isSending ? null : _sendMessage,
                  child: CircleAvatar(
                    backgroundColor:
                        _isSending ? Colors.grey : Colors.blue.shade600,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
