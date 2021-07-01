import 'package:chat_app/Controllers/ChatAPI.dart';
import 'package:chat_app/Models/Friend.dart';
import 'package:chat_app/Models/Message.dart';
import 'package:chat_app/Views/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key, @required this.friend}) : super(key: key);

  final Friend friend;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages;
  Stream<QuerySnapshot> _messagesStream;
  final ScrollController _scrollController = ScrollController();
  TextEditingController msgController = TextEditingController();
  ChatAPI chatAPI = ChatAPI();
  Uuid uuid = Uuid();
  var curUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    _messagesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(curUser.uid)
        .collection('friends')
        .doc(widget.friend.uid)
        .collection('messages')
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => LoginDemo()));
              },
            )
          ],
        ),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Message> a = [];
                    snapshot.data.docs.forEach((element) {
                      a.add(Message(
                        isMe: element['isMe'],
                        datetime: element['datetime'],
                        uid: element['uid'],
                        content: element['content'],
                      ));
                    });

                    a.sort((a, b) => a.datetime.compareTo(b.datetime));
                    a.forEach((element) {
                      print(element.datetime);
                    });

                    return ListView(
                      shrinkWrap: true,
                      children: a.map((Message data) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: (data.isMe == false
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (data.isMe == false
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Text(
                                data.content,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      controller: _scrollController,
                    );
                  }

                  return CircularProgressIndicator(
                    semanticsLabel: "Loading...",
                  );
                }),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                      String msgText = msgController.text.trim();
                      if (msgText.isNotEmpty) {
                        Message msg = Message(
                            uid: uuid.v4(),
                            content: msgText,
                            datetime: DateTime.now().toString());
                        chatAPI.postMessage(
                            curUser.uid, widget.friend.uid, msg);
                        msgController.clear();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
