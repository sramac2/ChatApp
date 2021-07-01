import 'package:chat_app/Models/Message.dart';

class Friend {
  String uid;
  String firstName;
  String lastName;
  List<Message> messages;

  Friend({this.uid, this.firstName, this.lastName, this.messages});

  Friend.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
