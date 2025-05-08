// Importing necessary packages
import 'package:carcare/theme_provider/themeprovider.dart'; // Theme provider for dark/light mode
import 'package:flutter/material.dart'; // Flutter's UI toolkit
import 'package:flutter_gemini/flutter_gemini.dart'; // Gemini package for AI responses
import 'package:carcare/common_widgets/common_widgets.dart'; // Custom widgets like the drawer
import 'package:provider/provider.dart'; // State management package

// Stateful widget for the ChatPage
class ChatPage extends StatefulWidget {
  const ChatPage({super.key}); // Constructor

  @override
  State<ChatPage> createState() => _ChatPageState(); // Creates the state
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController(); // Controller to handle user text input
  final List<Map<String, String>> _messages = []; // List to store chat messages (user and bot)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Scaffold key to control the drawer

  final gemini = Gemini.instance; // Gemini instance to interact with the AI

  bool _isSending = false; // Tracks if a message is currently being sent
  int selectedIndex = 5; // Selected index for the drawer menu

  @override
  void initState() {
    super.initState();
    // Initialize any state here if needed
  }

  // Function to handle sending a message
  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim(); // Get trimmed user input
    if (userMessage.isEmpty) return; // If empty, do nothing

    // Add user message to the chat and reset input field
    setState(() {
      _messages.add({'sender': 'user', 'text': userMessage});
      _controller.clear();
      _isSending = true; // Set sending status to true
    });

    try {
      // Send message to Gemini and get response
      final response = await gemini.text(userMessage);
      final botReply = response?.output ?? 'No response from Gemini.';

      // Add Gemini response to chat
      setState(() {
        _messages.add({'sender': 'bot', 'text': botReply});
      });
    } catch (e) {
      // Handle any error during API call
      setState(() {
        _messages.add({'sender': 'bot', 'text': 'Sorry, something went wrong.'});
      });
    } finally {
      // Reset sending status
      setState(() {
        _isSending = false;
      });
    }
  }

  // Widget to build individual chat messages (user or bot)
  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['sender'] == 'user'; // Check if it's user message
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, // Align based on sender
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue.shade600 : Colors.lightBlue, // Different color for user/bot
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message['text'] ?? '', // Display message text
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Main build method
  @override
  Widget build(BuildContext context) {
    // Check if dark mode is enabled from the provider
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      key: _scaffoldKey, // Assign scaffold key
      backgroundColor: isDark ? Colors.white : Colors.black87, // Background based on theme
      drawer: SideMenuDrawer(selectedIndex: selectedIndex), // Custom side menu drawer

      appBar: AppBar(
        backgroundColor: isDark ? Colors.white : Colors.black87, // AppBar color
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.chat, color: Colors.white), // Leading icon
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CarCare Bot',
              style: TextStyle(color: isDark ? Colors.black : Colors.white),
            ),
            Text(
              'Welcome to our Live Chat!',
              style: TextStyle(fontSize: 12, color: isDark ? Colors.black : Colors.white),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.menu, color: isDark ? Colors.black : Colors.white), // Drawer menu icon
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer(); // Open drawer
              },
            ),
          )
        ],
        elevation: 0, // No shadow under AppBar
      ),

      // Main body of the page
      body: Column(
        children: [
          // Display list of messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]); // Build each message
              },
            ),
          ),

          // Input area at bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                // Text field to enter user message
                Expanded(
                  child: TextField(
                    style: TextStyle(color: isDark ? Colors.black : Colors.white), // Text color based on theme
                    controller: _controller, // Attach controller
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(color: isDark ? Colors.black : Colors.white), // Hint style
                      filled: true,
                      fillColor: isDark ? Colors.white : Colors.black87, // Field background
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.blue.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.blue.shade400),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(), // Trigger send on enter
                  ),
                ),
                const SizedBox(width: 8),

                // Send button (disabled when sending)
                GestureDetector(
                  onTap: _isSending ? null : _sendMessage, // Prevent sending when already sending
                  child: CircleAvatar(
                    backgroundColor: _isSending ? Colors.grey : Colors.blue.shade600,
                    child: const Icon(Icons.send, color: Colors.white), // Send icon
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
