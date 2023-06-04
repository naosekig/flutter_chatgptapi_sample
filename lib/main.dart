import 'package:flutter/material.dart';
import 'package:flutter_chatgptapi_sample/repository/ai_chat_repository.dart';
import 'package:flutter_chatgptapi_sample/widget/ai_widget.dart';
import 'package:flutter_chatgptapi_sample/widget/chat_widget.dart';
import 'package:flutter_chatgptapi_sample/widget/question_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'model/chat_message.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ChatGPT API Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _chatMessages = [];
  String _question = '';
  bool _isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(top: 5, left: 5, right: 5),
                          child: TextFormField(
                              controller: _textEditingController,
                              enabled: !_isConnecting,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.top,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              scrollPadding: const EdgeInsets.all(5),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5, right: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _question = value;
                                });
                              }),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, right: 5),
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white),
                          onPressed:
                              (_question ?? '').isEmpty || (_isConnecting)
                                  ? null
                                  : () {
                                      setState(() {
                                        _isConnecting = true;
                                      });
                                      _getAiAnswer();
                                    },
                          child: const Text(
                            'Send',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: _getChatsList(),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _isConnecting,
                child: const Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getChatsList() {
    final List<Widget> widgets = [];

    for (final ChatMessage chatMessage in _chatMessages) {
      if (chatMessage.role == Role.USER) {
        widgets.add(
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const questionWidget(
                  margin: EdgeInsets.only(left: 5),
                ),
                Expanded(
                  child: ChatWidget(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    message: chatMessage.message,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (chatMessage.role == Role.ASSISTANT) {
        widgets.add(
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const aiWidget(
                  margin: EdgeInsets.only(left: 5),
                ),
                Expanded(
                  child: ChatWidget(
                    margin: const EdgeInsets.only(left: 5),
                    message: chatMessage.message,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Future<void> _getAiAnswer() async {
    final AiChatRepository _aiChatRepository = AiChatRepository();

    setState(() {
      _chatMessages.add(ChatMessage(message: _question, role: Role.USER));
    });

    final answer = await _aiChatRepository.getAiAnswer(_chatMessages);

    setState(() {
      _chatMessages.add(ChatMessage(message: answer!, role: Role.ASSISTANT));
      _isConnecting = false;
      _question = '';
    });
  }
}
