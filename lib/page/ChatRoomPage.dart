import 'dart:convert';
import 'package:chatroom/api.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/components/ChatBubble.dart';
import 'package:chatroom/components/TextField.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRoomPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatRoomPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserId,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? userId;
  String? userEmail;
  bool loading = true;
  List<dynamic> messageList = [];
  final TextEditingController _messageController = TextEditingController();

  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:3010'),
  );
  @override
  void initState() {
    super.initState();
    getMessage();
    getUserInfo();
    _messageController.text = '';
    _channel.stream.listen((message) {
      setState(() {
        messageList.add(jsonDecode(message));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void sendMessage() async {
    _channel.sink.add(_messageController.text);
    if (_messageController.text.isNotEmpty) {
      await APIS().addMessage(widget.receiverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  void getMessage() async {
    messageList = await APIS().getMessageList(widget.receiverUserId);

    setState(() => loading = false);
  }

  void getUserInfo() async {
    final SharedPreferences prefs = await _prefs;
    userId = prefs.getString('userId');
    userEmail = prefs.getString('userEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("${widget.receiverUserEmail}"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: messageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var alignment =
                        (messageList[index]['sender_id'].toString() ==
                                userId.toString())
                            ? Alignment.centerRight
                            : Alignment.centerLeft;
                    return Container(
                      alignment: alignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                              messageList[index]['sender_id'].toString() ==
                                      userId.toString()
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          mainAxisAlignment:
                              (messageList[index]['sender_id'].toString() ==
                                      userId.toString())
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            if (messageList[index]['sender_id'].toString() ==
                                userId.toString())
                              Text(widget.receiverUserEmail.toString()),
                            if (messageList[index]['sender_id'].toString() ==
                                widget.receiverUserId.toString())
                              Text(userEmail.toString()),
                            const SizedBox(height: 5),
                            ChatBubble(
                              message: messageList[index]['content'],
                              color:
                                  (messageList[index]['sender_id'].toString() ==
                                          userId.toString())
                                      ? Colors.blue
                                      : Colors.green,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: messageList[index]['date'] == null
                                  ? null
                                  : Text(
                                      '${DateFormat.yMd().add_jm().format(DateTime.parse(messageList[index]['date'] ?? ""))}'),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
          _buildMessageInput(),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        //text field
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: 'Enter message',
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        )
      ],
    );
  }
}
