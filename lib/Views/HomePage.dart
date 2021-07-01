import 'package:chat_app/Controllers/ChatAPI.dart';
import 'package:chat_app/Models/Friend.dart';
import 'package:chat_app/Views/ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Friend>> friendsList;
  ChatAPI chatAPI = ChatAPI();

  @override
  void initState() {
    var currUser = FirebaseAuth.instance.currentUser;
    friendsList = chatAPI.getAllFriends(currUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Friends'),
        ),
        body: FutureBuilder<List<Friend>>(
            future: friendsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    friend: snapshot.data[index],
                                  )));
                    },
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"),
                        ),
                        title: Text(
                            "${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
                      ),
                    ),
                  );
                }, itemCount: snapshot.data.length,);
              }
              return CircularProgressIndicator(
                semanticsLabel: "Loading...",
              );
            }),
      ),
    );
  }
}
