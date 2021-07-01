import 'Friend.dart';

class User {
  String firstName;
  String lastName;
  String datetime;
  String uid;
  String role;
  List<Friend> friends;
  User({this.firstName, this.lastName, this.datetime, this.uid, this.role});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    datetime = json['datetime'];
    uid = json['uid'];
    role = json['role'];
    if (json['friends'] != null) {
      friends = [];
      json['friends'].forEach((v) {
        friends.add(new Friend.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['datetime'] = this.datetime;
    data['uid'] = this.uid;
    data['role'] = this.role;
    if (this.friends != null) {
      data['friends'] = this.friends.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
