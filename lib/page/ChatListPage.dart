import 'package:chatroom/api.dart';
import 'package:chatroom/components/TextField.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/page/ChatRoomPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? userEmail;

  bool loading = true;
  List<dynamic> chatList = [];
  List<dynamic> filteredChatList = [];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getChatList();
    searchController.text = '';
    searchController.addListener(() {
      filterList();
    });
  }

  void filterList() {
    filteredChatList = chatList
        .where((item) => item['senderEmail']
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(filterList);
    searchController.dispose();
  }

  void signUserOut() async {
    Navigator.pushNamed(context, '/home');
  }

  void getChatList() async {
    final SharedPreferences prefs = await _prefs;

    userEmail = prefs.getString('userEmail');
    chatList = await APIS().getChatList();
    chatList = chatList.where((chat) {
      return chat['senderEmail'] != userEmail;
    }).toList();
    setState(() => loading = false);
  }

  void _signOut() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            title:
                Text(userEmail != null ? "welcome  $userEmail" : "Chat List"),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: () {
                  _signOut();
                },
              )
            ]),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextField(
                controller: searchController,
                hintText: 'Search by email',
                obscureText: false,
              ),
            ),
            Expanded(
                child:
                    searchController.text.isNotEmpty && filteredChatList.isEmpty
                        ? const Center(
                            child: Text("no result"),
                          )
                        : buildChatList()),
          ],
        ));
  }

  Widget buildChatList() {
    List<dynamic> data = [];
    if (filteredChatList.isNotEmpty) {
      data = filteredChatList;
    } else {
      data = chatList;
    }
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomPage(
                      receiverUserEmail: data[index]['senderEmail'],
                      receiverUserId: data[index]['senderId'].toString(),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                height: 100,
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text('${data[index]['senderEmail']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                            '${data[index]['sms'].toString().isEmpty ? "no conversation yet" : data[index]['sms']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: chatList[index]['date'] == null
                            ? null
                            : Text(
                                '${DateFormat.yMd().add_jm().format(DateTime.parse(chatList[index]['date'] ?? ""))}'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
